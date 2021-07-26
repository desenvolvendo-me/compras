class RemoveMaterialIdFromMaterialsControls < ActiveRecord::Migration
  def up
    remove_column :compras_materials_controls,
                  :material_id
  end

  def down
    add_column :compras_materials_controls,
               :material_id, :integer
    add_index :compras_materials_controls, :material_id
    add_foreign_key :compras_materials_controls, :compras_materials,
                    column: :material_id
  end
end