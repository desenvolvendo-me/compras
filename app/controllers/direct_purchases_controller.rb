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

      redirect_to supply_authorization
      return

    elsif params[:commit] == 'Enviar autorização de fornecimento por e-mail'

      html = render_to_string(:partial => "supply_authorizations", :locals => { :resource => resource.supply_authorization } )
      pdf = Pdf.new(self, html).generate!
      SupplyAuthorizationMailer.authorization_to_creditor(resource, current_prefecture, pdf).deliver

      redirect_to edit_direct_purchase_path(resource), :notice => t('compras.messages.supply_authorization_mailer_successful')
      return
    end

    set_purchase_solicitation(resource, params[:direct_purchase][:purchase_solicitation_id])

    super
  end

  protected

  def create_resource(object)
    object.transaction do
      if params[:direct_purchase]
        set_purchase_solicitation(object, params[:direct_purchase][:purchase_solicitation_id])
      end

      super

      PurchaseSolicitationBudgetAllocationItemFulfiller.new(object.purchase_solicitation_item_group, object).fulfill
    end
  end

  private

  def set_purchase_solicitation(direct_purchase, purchase_solicitation_id)
    return unless purchase_solicitation_id.present?

    purchase_solicitation = PurchaseSolicitation.find(purchase_solicitation_id)
    purchase_solicitation_process = PurchaseSolicitationProcess.new(direct_purchase)
    purchase_solicitation_process.set_solicitation(purchase_solicitation)
  end

end
