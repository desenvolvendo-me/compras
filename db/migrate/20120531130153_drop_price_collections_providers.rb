class DropPriceCollectionsProviders < ActiveRecord::Migration
  def change
    drop_table :price_collections_providers
  end
end
