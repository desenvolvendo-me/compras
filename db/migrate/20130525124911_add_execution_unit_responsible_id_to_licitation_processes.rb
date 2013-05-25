class AddExecutionUnitResponsibleIdToLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :execution_unit_responsible
    add_column    :compras_licitation_processes, :execution_unit_responsible_id, :integer
  end
end
