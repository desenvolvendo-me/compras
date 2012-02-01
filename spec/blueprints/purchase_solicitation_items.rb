PurchaseSolicitationItem.blueprint(:item) do
  material { Material.make!(:cadeira) }
  quantity { 10 }
  unit_price { 5 }
  estimated_total_price { 50 }
end
