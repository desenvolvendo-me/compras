DirectPurchaseBudgetAllocation.blueprint(:alocacao_compra) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  pledge_type { DirectPurchaseBudgetAllocationPledgeType::GLOBAL }
  items { [DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item)] }
end
