class PurchaseSolicitationItemGroupAnnulsController < ResourceAnnulsController
  protected

  def annul(object)
    purchase_solicitation_item_group = object.annullable

    PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
      :old_item_ids => purchase_solicitation_item_group.purchase_solicitation_item_ids
    ).change
  end

  def validate_parent!(object)
    raise Exceptions::Unauthorized unless object.annullable.annullable?

    super
  end
end
