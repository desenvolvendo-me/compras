class AddModalityTypeToLicitationModalities < ActiveRecord::Migration
  def change
    add_column :compras_licitation_modalities, :modality_type, :string
  end
end
