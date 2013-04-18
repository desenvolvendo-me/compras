TradingItem.blueprint(:item_pregao_presencial) do
  minimum_reduction_value { 0.01 }
  purchase_process_item {
    PurchaseProcessItem.make!(:item)
  }
end

TradingItem.blueprint(:segundo_item_pregao_presencial) do
  minimum_reduction_value { 0.01 }
  purchase_process_item {
    PurchaseProcessItem.make!(:item)
  }
end
