class CreateDepartmentPeople < ActiveRecord::Migration
  def change
    create_table :compras_department_people do |t|
      t.references :department, index: true, null: false
      t.references :person, index: true, null: false

      t.timestamps
    end
    add_foreign_key :compras_department_people, :compras_departments, column: :department_id
    add_foreign_key :compras_department_people, :unico_people, column: :person_id
  end
end
