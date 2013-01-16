class PurchaseSolicitationItemGroupAnnulment
  attr_accessor :purchase_solicitation_item_group, :item_status_changer

  def initialize(purchase_solicitation_item_group, options = {})
    self.purchase_solicitation_item_group = purchase_solicitation_item_group
    self.item_status_changer = options.fetch(:item_status_changer) { PurchaseSolicitationBudgetAllocationItemStatusChanger }
  end

  def annul
    item_status_changer.new(
      :old_purchase_solicitation_item_group => purchase_solicitation_item_group
    ).change

    purchase_solicitation_item_group.change_status!(PurchaseSolicitationItemGroupStatus::ANNULLED)
  end
end
