class RemoveMarketValueOfConstructionAndMarketValueOfTerrainFromPropertyTransfers < ActiveRecord::Migration
  def change
    remove_column :property_transfers, :market_value_of_construction
    remove_column :property_transfers, :market_value_of_terrain
  end
end
