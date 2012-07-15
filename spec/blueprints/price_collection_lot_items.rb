PriceCollectionLotItem.blueprint(:item_da_coleta) do
  material { Material.make!(:antivirus) }
  brand { 'Norton' }
  quantity { 10 }
end

PriceCollectionLotItem.blueprint(:arame) do
  material { Material.make!(:arame_comum) }
  brand { 'Tal' }
  quantity { 200 }
end
