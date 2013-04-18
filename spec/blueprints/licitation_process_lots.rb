LicitationProcessLot.blueprint(:lote) do
  observations { "observations" }
  purchase_process_items { [PurchaseProcessItem.make!(:item_arame)] }
end

LicitationProcessLot.blueprint(:lote_antivirus) do
  observations { "lote antivirus" }
  purchase_process_items { [PurchaseProcessItem.make!(:item)] }
end
