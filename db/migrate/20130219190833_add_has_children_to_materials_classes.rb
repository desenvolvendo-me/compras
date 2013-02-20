class AddHasChildrenToMaterialsClasses < ActiveRecord::Migration
  def change
    add_column :compras_materials_classes, :has_children, :boolean, :default => false

    MaterialsClass.find_each do |material_class|
      material_class.save!
    end
  end
end
