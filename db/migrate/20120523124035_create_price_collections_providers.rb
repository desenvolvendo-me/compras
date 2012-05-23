class CreatePriceCollectionsProviders < ActiveRecord::Migration
  def change
    create_table :price_collections_providers, :id => false do |t|
      t.integer :price_collection_id
      t.integer :provider_id
    end

    add_index :price_collections_providers, :price_collection_id, :name => 'pcp_price_collection_id'
    add_index :price_collections_providers, :provider_id, :name => 'pcp_provider_id'

    add_foreign_key :price_collections_providers, :price_collections, :name => 'pcp_price_collection_fk'
    add_foreign_key :price_collections_providers, :providers, :name => 'pcp_provider_fk'
  end
end
