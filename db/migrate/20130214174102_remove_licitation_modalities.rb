class RemoveLicitationModalities < ActiveRecord::Migration
  def change
    remove_column :compras_pledges, :licitation_modality_id
    remove_column :compras_reserve_funds, :licitation_modality_id

    drop_table :compras_licitation_modalities
  end
end
