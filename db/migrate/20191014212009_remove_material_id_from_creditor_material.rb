class RemoveMaterialIdFromCreditorMaterial < ActiveRecord::Migration
  def up
    remove_column :compras_creditor_materials, :material_id
  end

  def down
    add_column :compras_creditor_materials, :material_id, :integer

    add_index :compras_creditor_materials, :material_id

    add_foreign_key :compras_creditor_materials,
                    :compras_materials,
                    column: :material_id
  end
end
