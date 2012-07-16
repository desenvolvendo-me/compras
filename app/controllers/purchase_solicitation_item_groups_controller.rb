class PurchaseSolicitationItemGroupsController < CrudController

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(object.purchase_solicitation_ids).change
    end
  end

  def update_resource(object, attributes)
    object.transaction do
      old_purchase_solicitation_ids = object.purchase_solicitation_ids

      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(object.purchase_solicitation_ids, old_purchase_solicitation_ids).change
    end
  end

  def destroy_resource(object)
    object.transaction do
      old_purchase_solicitation_ids = object.purchase_solicitation_ids

      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(nil, old_purchase_solicitation_ids).change
    end
  end
end
