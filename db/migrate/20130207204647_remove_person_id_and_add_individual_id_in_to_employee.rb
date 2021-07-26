class RemovePersonIdAndAddIndividualIdInToEmployee < ActiveRecord::Migration
  def change
    add_column :compras_employees, :individual_id, :integer

    add_index :compras_employees, :individual_id

    add_foreign_key :compras_employees, :unico_individuals,
                    :column => :individual_id

    execute <<-SQL
        UPDATE compras_employees AS employee
        SET individual_id = (SELECT personable_id
                               FROM unico_people
                              WHERE id = employee.person_id and personable_type = 'Individual')
    SQL

    remove_column :compras_employees, :person_id
  end
end
