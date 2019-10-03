class AddMaterialIdToCreditorMaterial < ActiveRecord::Migration
  add_column :compras_creditor_materials, :material_id, :integer

  add_index :compras_creditor_materials, :material_id

  add_foreign_key :compras_creditor_materials,
                  :unico_materials,
                  column: :material_id
end
