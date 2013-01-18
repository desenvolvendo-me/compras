class AddDeliveryLocationIdToComprasLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :delivery_location_id, :integer

    add_index :compras_licitation_processes, :delivery_location_id
    add_foreign_key :compras_licitation_processes, :compras_delivery_locations, :column => :delivery_location_id

    LicitationProcess.joins { purchase_solicitation }.find_each do |licitation_process|
      licitation_process.update_column(:delivery_location_id, licitation_process.purchase_solicitation.delivery_location_id)
    end
  end
end
