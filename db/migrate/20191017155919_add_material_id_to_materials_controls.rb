class AddMaterialIdToMaterialsControls < ActiveRecord::Migration
  def change
    add_column :compras_materials_controls,
               :material_id, :integer
    add_index :compras_materials_controls, :material_id
    # add_foreign_key :compras_materials_controls, :unico_materials,
    #                 column: :material_id
  end
end
