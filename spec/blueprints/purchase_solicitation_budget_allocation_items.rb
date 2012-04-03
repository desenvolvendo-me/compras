PurchaseSolicitationBudgetAllocationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  brand { "Norton" }
  quantity { 3 }
  unit_price { 200.0 }
end
