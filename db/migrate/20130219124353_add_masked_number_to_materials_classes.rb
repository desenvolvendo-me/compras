class AddMaskedNumberToMaterialsClasses < ActiveRecord::Migration
  def change
    add_column :compras_materials_classes, :masked_number, :string

    MaterialsClass.find_each do |m|
      m.update_column(:masked_number, m.masked_class_number)
    end
  end
end
