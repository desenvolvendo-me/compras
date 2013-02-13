class RemoveLicitationModalityIdFromComprasAdministrativeProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_administrative_processes, :licitation_modality_id
  end
end
