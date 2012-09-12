# encoding: utf-8
class DirectPurchasesController < CrudController
  actions :all, :except => :destroy

  has_scope :authorized, :type => :boolean

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.date = Date.current
    object.year = Date.current.year

    super
  end

  def update
    if params[:commit] == 'Gerar autorização de fornecimento'
      supply_authorization = SupplyAuthorizationGenerator.new(resource).generate!

      SupplyAuthorizationMailer.authorization_to_creditor(resource, current_prefecture, pdf_supply_authorization).deliver

      redirect_to supply_authorization
      return

    elsif params[:commit] == 'Reenviar autorização de fornecimento por e-mail'

      SupplyAuthorizationMailer.authorization_to_creditor(resource, current_prefecture, pdf_supply_authorization).deliver

      redirect_to edit_direct_purchase_path(resource), :notice => t('compras.messages.supply_authorization_mailer_successful')
      return
    end

    super
  end

  protected

  def create_resource(object)
    object.direct_purchase = object.next_purchase
    object.transaction do
      super

      PurchaseSolicitationBudgetAllocationItemFulfiller.new(object.purchase_solicitation_item_group, object).fulfill
    end
  end

  def pdf_supply_authorization
    html = render_to_string(:partial => "supply_authorizations", :locals => { :resource => resource.supply_authorization } )

    pdf_instance = PDFKit.new html

    pdf_instance.stylesheets << "#{Rails.root}/public/assets/report.css"

    pdf_instance.to_pdf
  end
end
