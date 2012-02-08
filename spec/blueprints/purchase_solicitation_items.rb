PurchaseSolicitationItem.blueprint(:item) do
  material { Material.make!(:cadeira) }
  quantity { 10 }
  unit_price { 5 }
end
