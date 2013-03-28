PurchaseSolicitationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  brand { "Norton" }
  quantity { 3 }
  unit_price { 200.0 }
end

PurchaseSolicitationItem.blueprint(:arame_farpado) do
  material { Material.make!(:arame_farpado) }
  brand { "Arame" }
  quantity { 99 }
  unit_price { 200.0 }
end

PurchaseSolicitationItem.blueprint(:arame_farpado_2) do
  material { Material.make!(:arame_farpado) }
  brand { "Arame 2" }
  quantity { 10 }
  unit_price { 200.0 }
end

PurchaseSolicitationItem.blueprint(:office) do
  material { Material.make!(:office) }
  brand { "Office" }
  quantity { 3 }
  unit_price { 200.0 }
end
