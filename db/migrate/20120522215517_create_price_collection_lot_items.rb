class CreatePriceCollectionLotItems < ActiveRecord::Migration
  def change
    create_table :price_collection_lot_items do |t|
      t.references :price_collection_lot
      t.references :material
      t.integer :quantity
      t.string :brand

      t.timestamps
    end

    add_index :price_collection_lot_items, :price_collection_lot_id
    add_index :price_collection_lot_items, :material_id

    add_foreign_key :price_collection_lot_items, :price_collection_lots
    add_foreign_key :price_collection_lot_items, :materials
  end
end
