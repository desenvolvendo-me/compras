class AdministrativeProcessBudgetAllocationCleaner
  def initialize(licitation_process, item_group)
    @licitation_process = licitation_process
    @item_group = item_group
  end

  def clear_old_records
    return unless item_group_changed?

    licitation_process.administrative_process_budget_allocations.each(&:mark_for_destruction)
  end

  private

  attr_reader :licitation_process, :item_group

  def item_group_changed?
    licitation_process.purchase_solicitation_item_group != item_group
  end
end
