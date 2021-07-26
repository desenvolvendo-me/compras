class RemoveAdministrativeProcesses < ActiveRecord::Migration
  def change
    drop_table :compras_administrative_processes
  end
end
