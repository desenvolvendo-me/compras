TradingItem.blueprint(:item_pregao_presencial) do
  order { 1 }
  administrative_process_budget_allocation_item {
    AdministrativeProcessBudgetAllocationItem.make!(:item)
  }
end
