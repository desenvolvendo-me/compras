class AddImportedToMaterialClass < ActiveRecord::Migration
  def change
    add_column :compras_materials_classes, :imported, :boolean, :default => false
  end
end
