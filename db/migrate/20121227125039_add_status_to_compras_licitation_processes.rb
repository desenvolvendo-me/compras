class AddStatusToComprasLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :status, :string
  end
end
