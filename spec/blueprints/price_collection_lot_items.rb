PriceCollectionLotItem.blueprint(:item_da_coleta) do
  material { Material.make!(:antivirus) }
  brand { 'Norton' }
  quantity { 10 }
end

PriceCollectionLotItem.blueprint(:office) do
  material { Material.make!(:office) }
  brand { 'MS' }
  quantity { 2 }
end

PriceCollectionLotItem.blueprint(:arame) do
  material { Material.make!(:arame_comum) }
  brand { 'Tal' }
  quantity { 200 }
end