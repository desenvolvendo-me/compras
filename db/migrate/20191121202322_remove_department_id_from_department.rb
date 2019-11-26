class RemoveDepartmentIdFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,:department_id
  end
end
