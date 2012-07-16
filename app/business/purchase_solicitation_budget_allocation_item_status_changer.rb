class PurchaseSolicitationBudgetAllocationItemStatusChanger
  attr_accessor :items_ids, :old_items_ids, :status

  def initialize(items_ids = nil, old_items_ids = nil, status = PurchaseSolicitationBudgetAllocationItemStatus)
    self.items_ids = items_ids
    self.old_items_ids = old_items_ids
    self.status = status
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
    if items_ids
      old_items_ids - items_ids
    else
      old_items_ids
    end
  end
end
