# encoding: utf-8
AdministrativeProcessBudgetAllocation.blueprint(:alocacao) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 20.0 }
end
