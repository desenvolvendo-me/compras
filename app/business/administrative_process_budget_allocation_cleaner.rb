class AdministrativeProcessBudgetAllocationCleaner
  def initialize(administrative_process, item_group)
    @administrative_process = administrative_process
    @item_group = item_group
  end

  def clear_old_records
    return unless item_group_changed?

    @administrative_process.administrative_process_budget_allocations.each(&:mark_for_destruction)
  end

  private

  def item_group_changed?
    @administrative_process.purchase_solicitation_item_group != @item_group
  end
end
