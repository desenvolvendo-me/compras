class AddDeliveryLocationIdToComprasLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :delivery_location_id, :integer

    add_index :compras_licitation_processes, :delivery_location_id
    add_foreign_key :compras_licitation_processes, :compras_delivery_locations, :column => :delivery_location_id

    execute <<-SQL
      UPDATE compras_licitation_processes a
        SET delivery_location_id = b.delivery_location_id
      FROM compras_purchase_solicitations b
        JOIN compras_administrative_processes c
        ON c.purchase_solicitation_id = b.id
      WHERE a.administrative_process_id = c.id
    SQL
  end
end
