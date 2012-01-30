class AddClassNumberToMaterialsClasses < ActiveRecord::Migration
  def change
    add_column :materials_classes, :class_number, :string
  end
end
