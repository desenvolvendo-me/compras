PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria) do
  budget_allocation_id { 1 }
  estimated_value { 20.0 }
  expense_nature_id { 1 }
  blocked { false }
end

PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria_2013) do
  budget_allocation_id { 1 }
  blocked { false }
end

PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria_office) do
  budget_allocation_id { 1 }
  blocked { false }
end
