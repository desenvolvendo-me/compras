class RemoveDepartmentGroupFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,
                  :departments_group_id
  end
end
