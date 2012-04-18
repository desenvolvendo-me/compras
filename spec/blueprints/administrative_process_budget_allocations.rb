# encoding: utf-8
AdministrativeProcessBudgetAllocation.blueprint(:alocacao) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 20.0 }
end

AdministrativeProcessBudgetAllocation.blueprint(:alocacao_com_itens) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 20.0 }
  items { [AdministrativeProcessBudgetAllocationItem.make!(:item)] }
end
