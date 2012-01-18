class AddDescriptionToRatePropertyTransfers < ActiveRecord::Migration
  def change
    add_column :rate_property_transfers, :description, :string
  end
end
