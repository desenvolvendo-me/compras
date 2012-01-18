class RemoveRateIdAndFundedRateIdFromPropertyTransfers < ActiveRecord::Migration
  def change
    remove_index :property_transfers, :rate_id
    remove_index :property_transfers, :funded_rate_id
    remove_foreign_key :property_transfers, :column => :rate_id
    remove_foreign_key :property_transfers, :column => :funded_rate_id
    remove_column :property_transfers, :rate_id
    remove_column :property_transfers, :funded_rate_id
  end
end
