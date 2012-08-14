PriceCollectionLot.blueprint(:lote_da_coleta) do
  observations { 'lote da coleta' }
  items { [PriceCollectionLotItem.make!(:item_da_coleta, :price_collection_lot => object)] }
end

PriceCollectionLot.blueprint(:lote_da_coleta_com_2_itens) do
  observations { 'lote da coleta' }
  items { [PriceCollectionLotItem.make!(:item_da_coleta, :price_collection_lot => object),
           PriceCollectionLotItem.make!(:office, :price_collection_lot => object)] }
end

PriceCollectionLot.blueprint(:arames) do
  observations { 'arames' }
  items { [PriceCollectionLotItem.make!(:arame, :price_collection_lot => object)] }
end
