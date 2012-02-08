class RenameNameOnMaterialsClasses < ActiveRecord::Migration
  def change
    rename_column :materials_classes, :name, :description
  end
end
