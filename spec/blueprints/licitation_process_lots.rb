LicitationProcessLot.blueprint(:lote) do
  observations { "observations" }
  administrative_process_budget_allocation_items { [AdministrativeProcessBudgetAllocationItem.make!(:item_arame)] }
end

LicitationProcessLot.blueprint(:lote_antivirus) do
  observations { "lote antivirus" }
  administrative_process_budget_allocation_items { [AdministrativeProcessBudgetAllocationItem.make!(:item)] }
end
