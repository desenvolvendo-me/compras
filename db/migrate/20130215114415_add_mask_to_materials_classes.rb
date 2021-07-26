class AddMaskToMaterialsClasses < ActiveRecord::Migration
  def change
    add_column :compras_materials_classes, :mask, :string, :require => true
  end
end
