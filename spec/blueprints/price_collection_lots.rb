PriceCollectionLot.blueprint(:lote_da_coleta) do
  observations { 'lote da coleta' }
  items { [PriceCollectionLotItem.make!(:item_da_coleta)] }
end
