class RemoveRatePropertyTransfers < ActiveRecord::Migration
  def change
    drop_table :rate_property_transfers
  end
end
