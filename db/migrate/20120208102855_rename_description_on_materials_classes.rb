class RenameDescriptionOnMaterialsClasses < ActiveRecord::Migration
  def change
    rename_column :materials_classes, :description, :details
  end
end
