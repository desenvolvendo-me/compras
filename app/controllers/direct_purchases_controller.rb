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

  def create
    create! do |success, failure|
      success.html { redirect_to edit_resource_path(resource) }
    end
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

    update! do |success, failure|
      success.html { redirect_to edit_resource_path(resource) }
    end
  end

  protected

  def interpolation_options
    { :resource_name => "#{resource_class.model_name.human} #{resource.code}/#{resource.year}" }
  end

  def create_resource(object)
    object.transaction do
      if super
        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => object.purchase_solicitation_item_group,
          :direct_purchase => object,
          :add_fulfill => true).fulfill

        if params[:direct_purchase]
          PurchaseSolicitationItemGroupProcess.new(:new_item_group => new_item_group).update_status
          PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
            :new_purchase_solicitation => new_purchase_solicitation,
            :direct_purchase => object).change
          PurchaseSolicitationStatusChanger.change(new_purchase_solicitation)
        end
      end
    end
  end

  def update_resource(object, attributes)
    old_item_group = object.purchase_solicitation_item_group
    old_purchase_solicitation = object.purchase_solicitation

    object.transaction do
      DirectPurchaseBudgetAllocationCleaner.clear_old_records(object, new_purchase_solicitation, new_item_group)

      if super
        PurchaseSolicitationItemGroupProcess.new(
          :new_item_group => new_item_group, :old_item_group => old_item_group).update_status
          PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
            :new_purchase_solicitation => new_purchase_solicitation,
            :old_purchase_solicitation => old_purchase_solicitation,
            :direct_purchase => object).change
          PurchaseSolicitationStatusChanger.change(new_purchase_solicitation)
          PurchaseSolicitationStatusChanger.change(old_purchase_solicitation)

        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => old_item_group,
          :direct_purchase => object).fulfill
        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => new_item_group,
          :direct_purchase => object,
          :add_fulfill => true).fulfill
      end
    end
  end

  private

  def new_purchase_solicitation
    purchase_solicitation_id = params[:direct_purchase][:purchase_solicitation_id]

    PurchaseSolicitation.find(purchase_solicitation_id) if purchase_solicitation_id.present?
  end

  def new_item_group
    item_group_id = params[:direct_purchase][:purchase_solicitation_item_group_id]

    PurchaseSolicitationItemGroup.find(item_group_id) if item_group_id.present?
  end
end
