DirectPurchaseBudgetAllocationItem.blueprint(:compra_direta_item) do
  material { Material.make!(:antivirus) }
  brand { "Norton" }
  quantity { 3 }
  unit_price { 200.0 }
end

DirectPurchaseBudgetAllocationItem.blueprint(:compra_direta_item_extra) do
  material { Material.make!(:antivirus) }
  brand { "Norton" }
  quantity { 3 }
  unit_price { 200.0 }
end

DirectPurchaseBudgetAllocationItem.blueprint(:compra_direta_item_engenharia) do
  material { Material.make!(:antivirus) }
  brand { "Norton" }
  quantity { 3 }
  unit_price { 200.0 }
end

DirectPurchaseBudgetAllocationItem.blueprint(:kaspersky) do
  material { Material.make!(:antivirus) }
  brand { 'Kaspersky' }
  quantity { 1 }
  unit_price { 9000.0 }
end
