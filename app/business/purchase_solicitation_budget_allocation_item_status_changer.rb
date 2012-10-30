class PurchaseSolicitationBudgetAllocationItemStatusChanger
  attr_accessor :new_item_ids, :old_item_ids

  # Change the status of purchase solicitation budget allocation item.
  #
  #   The new purchase solicitation
  #
  #   options - a hash that contains the new and old purchase solicitation ids [:new_ids, :old_ids]
  #
  # Examples:
  #
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:new_item_ids => new_item_ids).change
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:new_item_ids => new_item_ids, :old_items_ids => old_items_ids).change
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:old_items_ids => old_items_ids).change
  def initialize(options = {})
    self.new_item_ids = options.fetch(:new_item_ids, [])
    self.old_item_ids = options.fetch(:old_item_ids, [])
  end

  def change(item_repository = PurchaseSolicitationBudgetAllocationItem)
    item_repository.group!(new_item_ids) if new_item_ids.any?

    item_repository.pending!(removed_item_ids) if old_item_ids.any?
  end

  protected

  def removed_item_ids
    old_item_ids - new_item_ids
  end
end
