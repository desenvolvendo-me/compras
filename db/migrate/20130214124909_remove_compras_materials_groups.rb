class RemoveComprasMaterialsGroups < ActiveRecord::Migration
  def change
    remove_column :compras_materials_classes, :materials_group_id

    drop_table :compras_materials_groups
  end
end
