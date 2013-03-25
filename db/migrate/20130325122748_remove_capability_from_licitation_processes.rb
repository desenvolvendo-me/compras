class RemoveCapabilityFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :capability_id
  end
end
