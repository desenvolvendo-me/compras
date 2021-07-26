class RemoveFieldsFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :licitation_number
    remove_column :compras_licitation_processes, :responsible_id
    remove_column :compras_licitation_processes, :item
    remove_column :compras_licitation_processes, :pledge_type
  end
end
