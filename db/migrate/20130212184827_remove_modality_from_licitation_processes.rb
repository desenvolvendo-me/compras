class RemoveModalityFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :modality
  end
end
