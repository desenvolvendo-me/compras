class PurchaseSolicitationItemGroupAnnulsController < ResourceAnnulsController
  protected

  def annul(object)
    PurchaseSolicitationBudgetAllocationItemStatusChanger.new({
      :old_item_ids => object.purchase_solicitation_ids
    }).change
  end

  def validate_parent!(object)
    raise Exceptions::Unauthorized unless object.annullable.annullable?

    super
  end
end
