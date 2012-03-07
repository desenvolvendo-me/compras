DirectPurchaseItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  brand { "desc cadeiras" }
  quantity { 1 }
  unit_price { 9.99 }
end
