class RenameTableMaterialsClassesToMaterialClasses < ActiveRecord::Migration
  def change
    rename_table :compras_materials_classes, :compras_material_classes
    rename_column :compras_materials, :materials_class_id, :material_class_id
  end
end
