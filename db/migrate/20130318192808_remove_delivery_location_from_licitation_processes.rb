class RemoveDeliveryLocationFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :delivery_location_id
  end
end
