class ChangeDeliveryLocationsCollumnNameToDescription < ActiveRecord::Migration
  def change
    rename_column :delivery_locations, :name, :description
  end
end
