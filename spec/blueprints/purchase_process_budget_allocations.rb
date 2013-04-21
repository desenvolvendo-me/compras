# encoding: utf-8
PurchaseProcessBudgetAllocation.blueprint(:alocacao) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 20.0 }
end

PurchaseProcessBudgetAllocation.blueprint(:alocacao_com_itens) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 20.0 }
end

PurchaseProcessBudgetAllocation.blueprint(:alocacao_com_2_itens) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 30.0 }
end
