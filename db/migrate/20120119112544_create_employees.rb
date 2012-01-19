class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :person
      t.string :registration

      t.timestamps
    end
    add_index :employees, :person_id
    add_foreign_key :employees, :people
  end
end
