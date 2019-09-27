class AddDepartmentIdToLicitationProcess < ActiveRecord::Migration

  def up
    add_column :compras_licitation_processes, :department_id, :integer

    add_foreign_key :compras_licitation_processes, :compras_departments,
                    column: :department_id

    add_index :compras_licitation_processes, :department_id
  end

  def down
    remove_column :compras_licitation_processes, :department_id
  end

end
