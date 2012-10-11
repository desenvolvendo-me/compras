DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item)] }
end

DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra_extra) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item)] }
end

DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra_engenharia) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item)] }
end

DirectPurchaseBudgetAllocation.blueprint(:valores_proximo_ao_limite) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  items { [DirectPurchaseBudgetAllocationItem.make!(:kaspersky)] }
end
