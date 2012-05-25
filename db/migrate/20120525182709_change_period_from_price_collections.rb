class ChangePeriodFromPriceCollections < ActiveRecord::Migration
  def change
    remove_column :price_collections, :period_id
    remove_column :price_collections, :proposal_validity_id

    add_column :price_collections, :period, :integer
    add_column :price_collections, :period_unit, :string
    add_column :price_collections, :proposal_validity, :integer
    add_column :price_collections, :proposal_validity_unit, :string
  end
end
