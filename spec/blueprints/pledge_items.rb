PledgeItem.blueprint(:item) do
  material { Material.make!(:arame_farpado) }
  quantity { 1 }
  unit_price { 9.99 }
  description { "desc cadeiras" }
end
