DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  pledge_type { DirectPurchaseBudgetAllocationPledgeType::GLOBAL }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item)] }
end

DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra_extra) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  pledge_type { DirectPurchaseBudgetAllocationPledgeType::GLOBAL }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item_extra)] }
end

DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra_engenharia) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  pledge_type { DirectPurchaseBudgetAllocationPledgeType::GLOBAL }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item_engenharia)] }
end
