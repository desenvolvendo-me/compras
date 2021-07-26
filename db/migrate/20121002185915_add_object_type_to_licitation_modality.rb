class AddObjectTypeToLicitationModality < ActiveRecord::Migration
  def change
    add_column :compras_licitation_modalities, :object_type, :string

    add_index :compras_licitation_modalities, :object_type
  end
end
