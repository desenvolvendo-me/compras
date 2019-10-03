class RemoveMaterialIdFromCreditorMaterial < ActiveRecord::Migration
  remove_column :compras_creditor_materials, :material_id
end