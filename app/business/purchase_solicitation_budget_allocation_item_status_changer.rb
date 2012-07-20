class PurchaseSolicitationBudgetAllocationItemStatusChanger
  attr_accessor :items_ids, :old_items_ids

  def initialize(items_ids = [], old_items_ids = [])
    self.items_ids = items_ids
    self.old_items_ids = old_items_ids
  end

  def change
    if items_ids
      items(items_ids).grouped!
    end

    if old_items_ids
      items(removed_items_ids).pending!
    end
  end

  protected

  def items(ids)
    PurchaseSolicitationBudgetAllocationItem.where { id.in( my{ids} ) }
  end

  def removed_items_ids
    old_items_ids - items_ids
  end
end
