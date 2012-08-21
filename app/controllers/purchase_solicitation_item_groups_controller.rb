class PurchaseSolicitationItemGroupsController < CrudController
  actions :all, :except => :destroy

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new({
        :new_item_ids => object.purchase_solicitation_ids
      }).change
    end
  end

  def update_resource(object, attributes)
    object.transaction do
      old_purchase_solicitation_ids = object.purchase_solicitation_ids

      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new({
        :new_item_ids => object.purchase_solicitation_ids,
        :old_item_ids => old_purchase_solicitation_ids
      }).change
    end
  end
end
