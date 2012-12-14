TradingItem.blueprint(:item_pregao_presencial) do
  order { 1 }
  minimum_reduction_value { 0.01 }
  administrative_process_budget_allocation_item {
    AdministrativeProcessBudgetAllocationItem.make!(:item)
  }
end

TradingItem.blueprint(:segundo_item_pregao_presencial) do
  order { 2 }
  minimum_reduction_value { 0.01 }
  administrative_process_budget_allocation_item {
    AdministrativeProcessBudgetAllocationItem.make!(:item)
  }
end
