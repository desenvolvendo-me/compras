class CreatePriceCollectionLots < ActiveRecord::Migration
  def change
    create_table :price_collection_lots do |t|
      t.references :price_collection
      t.text :observations

      t.timestamps
    end

    add_index :price_collection_lots, :price_collection_id

    add_foreign_key :price_collection_lots, :price_collections
  end
end
