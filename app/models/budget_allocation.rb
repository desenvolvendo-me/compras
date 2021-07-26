class BudgetAllocation < UnicoAPI::Resources::Contabilidade::BudgetAllocation
  include BelongsToResource

  belongs_to_resource :expense_nature
  belongs_to_resource :budget_structure

  def autocomplete_budget_allocation
    "#{code} - #{expense_nature.description}"
  end

  def can_be_used?(purchase_process)
    !has_reserve_fund?(purchase_process) && !has_pledge_request?(purchase_process)
  end

  def balance
    attributes[:balance].to_d
  end

  private

  def has_pledge_request?(purchase_process)
    Pledge.
      by_purchase_process_id(purchase_process.id).
      select { |pledge| pledge.budget_allocation_id == id }.
      any?
  end

  def has_reserve_fund?(purchase_process)
    ReserveFund.
      by_purchase_process_id(purchase_process.id).
      select { |reserve| reserve.budget_allocation_id == id }.
      any?
  end
end
