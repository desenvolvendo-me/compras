class RemoveClassNumberFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,:class_number
  end
end
