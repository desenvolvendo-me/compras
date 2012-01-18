class RemoveYearFromRatePropertyTransfers < ActiveRecord::Migration
  def change
    remove_column :rate_property_transfers, :year
  end
end
