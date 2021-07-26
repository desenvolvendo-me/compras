class AddMaskedNumberToMaterialsClasses < ActiveRecord::Migration
  def change
    add_column :compras_materials_classes, :masked_number, :string
  end
end
