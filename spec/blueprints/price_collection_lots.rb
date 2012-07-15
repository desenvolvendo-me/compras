PriceCollectionLot.blueprint(:lote_da_coleta) do
  observations { 'lote da coleta' }
  items { [PriceCollectionLotItem.make!(:item_da_coleta, :price_collection_lot => object)] }
end

PriceCollectionLot.blueprint(:arames) do
  observations { 'arames' }
  items { [PriceCollectionLotItem.make!(:arame, :price_collection_lot => object)] }
end
