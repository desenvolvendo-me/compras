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
      SupplyAuthorizationEmailSender.new(resource.supply_authorization, self).deliver

      redirect_to edit_direct_purchase_path(resource), :notice => t('compras.messages.supply_authorization_mailer_successful')
      return
    end

    super
  end

  protected

  def create_resource(object)
    object.transaction do
      if params[:direct_purchase]
        set_purchase_solicitation(object, params[:direct_purchase][:purchase_solicitation_id])
        update_item_group_status(object, params[:direct_purchase][:purchase_solicitation_item_group_id])
      end

      super

      PurchaseSolicitationBudgetAllocationItemFulfiller.new(object.purchase_solicitation_item_group, object).fulfill
    end
  end

  def update_resource(object, attributes)
    object.transaction do
      set_purchase_solicitation(object, params[:direct_purchase][:purchase_solicitation_id])
      update_item_group_status(object, params[:direct_purchase][:purchase_solicitation_item_group_id])

      super
    end
  end

  private

  def set_purchase_solicitation(direct_purchase, purchase_solicitation_id)
    return unless purchase_solicitation_id.present?

    purchase_solicitation = PurchaseSolicitation.find(purchase_solicitation_id)
    purchase_solicitation_process = PurchaseSolicitationProcess.new(direct_purchase)
    purchase_solicitation_process.set_solicitation(purchase_solicitation)
  end

  def update_item_group_status(direct_purchase, item_group_id)
    return unless item_group_id.present?

    item_group = PurchaseSolicitationItemGroup.find(item_group_id)
    item_group_process = PurchaseSolicitationItemGroupProcess.new(direct_purchase)
    item_group_process.update_item_group_status(item_group)
  end
end
