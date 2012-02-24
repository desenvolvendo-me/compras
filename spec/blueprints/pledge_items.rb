PledgeItem.blueprint(:item) do
  material { Material.make!(:cadeira) }
  quantity { 1 }
  unit_price { 9.99 }
  description { "desc cadeiras" }
end
