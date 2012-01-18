class RemoveRegistryCodeFromPropertyTransfers < ActiveRecord::Migration
  def change
    remove_column :property_transfers, :registry_code
  end
end
