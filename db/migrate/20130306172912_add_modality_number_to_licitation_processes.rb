class AddModalityNumberToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :modality_number, :integer
  end
end
