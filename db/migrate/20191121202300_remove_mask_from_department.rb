class RemoveMaskFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,:mask
  end
end
