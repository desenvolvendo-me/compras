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

      SupplyAuthorizationMailer.authorization_to_creditor(resource).deliver

      redirect_to supply_authorization
      return

    elsif params[:commit] == 'Reenviar autorização de fornecimento por e-mail'
      SupplyAuthorizationMailer.authorization_to_creditor(resource).deliver

      redirect_to edit_direct_purchase_path(resource), :notice => t('compras.messages.supply_authorization_mailer_successful')
      return
    end

    super
  end

  protected

  def create_resource(object)
    object.direct_purchase = object.next_purchase

    super
  end
end
