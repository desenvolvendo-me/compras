class AddUserToDepartmentPeople < ActiveRecord::Migration
  def change
    add_column :compras_department_people,
               :user_id, :integer
    add_index :compras_department_people, :user_id
    add_foreign_key :compras_department_people, :compras_users,
                    :column => :user_id
  end
end
