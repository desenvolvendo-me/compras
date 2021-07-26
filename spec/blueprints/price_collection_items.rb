PriceCollectionItem.blueprint(:item_da_coleta) do
  lot { 150323232 }
  material { Material.make!(:antivirus) }
  brand { 'Norton' }
  quantity { 10 }
end

PriceCollectionItem.blueprint(:office) do
  lot { 1503131 }
  material { Material.make!(:office) }
  brand { 'MS' }
  quantity { 2 }
end

PriceCollectionItem.blueprint(:arame) do
  lot { 1503030 }
  material { Material.make!(:arame_comum) }
  brand { 'Tal' }
  quantity { 200 }
end
