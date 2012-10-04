class AddLicitationModalityIdToAdministrativeProcess < ActiveRecord::Migration
  def change
    add_column :compras_administrative_processes, :licitation_modality_id, :integer

    add_index :compras_administrative_processes, :licitation_modality_id, :name => :compras_ap_on_licitation_modality_id

    add_foreign_key :compras_administrative_processes, :compras_licitation_modalities,
                    :column => :licitation_modality_id

    AdministrativeProcess.all.each do |administrative_process|
      administrative_process.update_column(:licitation_modality_id, 2)
    end

    remove_column :compras_administrative_processes, :modality
  end
end
