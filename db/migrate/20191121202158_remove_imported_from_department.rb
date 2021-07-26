class RemoveImportedFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,:imported
  end
end
