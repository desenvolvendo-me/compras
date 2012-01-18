class MakeFundedDefaultInRatePropertyTransfersToFalse < ActiveRecord::Migration
  def change
    change_column :rate_property_transfers, :funded, :boolean, :default => false
  end
end
