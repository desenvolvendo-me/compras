class BudgetAllocation < UnicoAPI::Resources::Contabilidade::BudgetAllocation
  def autocomplete_budget_allocation
    "#{code} - #{expense_nature.description}"
  end
end
