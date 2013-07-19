class BudgetAllocation < UnicoAPI::Resources::Contabilidade::BudgetAllocation
  include BelongsToResource

  belongs_to_resource :expense_nature

  def autocomplete_budget_allocation
    "#{code} - #{expense_nature.description}"
  end
end
