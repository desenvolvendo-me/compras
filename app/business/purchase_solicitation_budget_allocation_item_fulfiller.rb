class PurchaseSolicitationBudgetAllocationItemFulfiller
  attr_accessor :purchase_solicitation_item_group, :process

  def initialize(purchase_solicitation_item_group, process)
    self.purchase_solicitation_item_group = purchase_solicitation_item_group
    self.process = process
  end

  def fulfill
    return unless purchase_solicitation_item_group.present?

    purchase_solicitation_item_group.purchase_solicitation_items_by_materials.each do |purchase_solicitation_item|
      purchase_solicitation_item.update_fulfiller(process)
    end
  end
end
