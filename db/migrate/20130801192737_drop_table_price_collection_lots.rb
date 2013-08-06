class DropTablePriceCollectionLots < ActiveRecord::Migration
  def change
    drop_table :compras_price_collection_lots
  end
end
