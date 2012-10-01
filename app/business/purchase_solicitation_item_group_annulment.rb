class PurchaseSolicitationItemGroupAnnulment
  attr_accessor :purchase_solicitation_item_group, :item_status_changer

  def initialize(purchase_solicitation_item_group, item_status_changer = PurchaseSolicitationBudgetAllocationItemStatusChanger)
    self.purchase_solicitation_item_group = purchase_solicitation_item_group
    self.item_status_changer = item_status_changer
  end

  def annul
    item_status_changer.new({
      :old_item_ids => purchase_solicitation_item_group.purchase_solicitation_item_ids
    }).change
  end
end
