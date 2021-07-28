class AddDepartmentNumberToDepartment < ActiveRecord::Migration
  def change
    add_column :compras_departments, :department_number, :integer
  end
end