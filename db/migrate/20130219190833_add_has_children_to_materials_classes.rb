class AddHasChildrenToMaterialsClasses < ActiveRecord::Migration
  def change
    add_column :compras_materials_classes, :has_children, :boolean, :default => false
  end
end
