class RenameNewModalityToModalityAtAdminsitrativeProcesses < ActiveRecord::Migration
  def change
    rename_column :compras_administrative_processes, :new_modality, :modality
  end
end
