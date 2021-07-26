class RemoveAdministrativeProcessIdFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :administrative_process_id
  end
end
