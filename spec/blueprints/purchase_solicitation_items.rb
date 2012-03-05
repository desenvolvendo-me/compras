PurchaseSolicitationItem.blueprint(:item) do
  material { Material.make!(:arame_farpado) }
  quantity { 10 }
  unit_price { 5 }
end
