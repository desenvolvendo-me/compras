PriceCollectionLotItem.blueprint(:item_da_coleta) do
  lot {'150323232'}
  material { Material.make!(:antivirus) }
  brand { 'Norton' }
  quantity { 10 }
end

PriceCollectionLotItem.blueprint(:office) do
  lot {'1503131'}
  material { Material.make!(:office) }
  brand { 'MS' }
  quantity { 2 }
end

PriceCollectionLotItem.blueprint(:arame) do
  lot {'1503030'}
  material { Material.make!(:arame_comum) }
  brand { 'Tal' }
  quantity { 200 }
end
