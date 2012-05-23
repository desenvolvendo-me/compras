class CreatePriceCollectionProposals < ActiveRecord::Migration
  def change
    create_table :price_collection_proposals do |t|
      t.references :price_collection
      t.references :provider

      t.timestamps
    end

    add_index :price_collection_proposals, :price_collection_id
    add_index :price_collection_proposals, :provider_id

    add_foreign_key :price_collection_proposals, :price_collections
    add_foreign_key :price_collection_proposals, :providers
  end
end
