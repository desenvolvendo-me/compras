class RemotePriceCollectionLotIdFromPriceCollectionItems < ActiveRecord::Migration
  def change
    remove_column :compras_price_collection_items, :price_collection_lot_id

    add_column :compras_price_collection_items, :price_collection_id, :integer

    add_foreign_key :compras_price_collection_items, :compras_price_collections,
      column: :price_collection_id

    add_index :compras_price_collection_items, :price_collection_id
  end
end
