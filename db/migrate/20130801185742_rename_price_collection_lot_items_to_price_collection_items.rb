class RenamePriceCollectionLotItemsToPriceCollectionItems < ActiveRecord::Migration
  def up
    rename_table :compras_price_collection_lot_items, :compras_price_collection_items
  end

  def down
    rename_table :compras_price_collection_items, :compras_price_collection_lot_items
  end
end
