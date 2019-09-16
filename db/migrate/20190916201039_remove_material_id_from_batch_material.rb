class RemoveMaterialIdFromBatchMaterial < ActiveRecord::Migration
  def up
    remove_column :compras_batch_materials, :material_id
  end

  def down
    add_column :compras_batch_materials, :material_id, :integer
    add_index :compras_batch_materials, :material_id
    add_foreign_key :compras_batch_materials, :compras_materials, column: :material_id
  end
end
