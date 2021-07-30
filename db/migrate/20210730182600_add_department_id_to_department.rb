class AddDepartmentIdToDepartment < ActiveRecord::Migration
    def change
      add_column :compras_departments, :department_id, :integer 
    end
end