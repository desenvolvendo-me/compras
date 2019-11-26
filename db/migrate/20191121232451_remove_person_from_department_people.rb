class RemovePersonFromDepartmentPeople < ActiveRecord::Migration
  remove_column :compras_department_people,
                :person_id
end
