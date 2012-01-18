class RemovePropertyIdFromExemptionRequests < ActiveRecord::Migration
  def change
    remove_column :exemption_requests, :property_id
  end
end
