class CreateDemandDepartments < ActiveRecord::Migration
  def change
    create_table :compras_demand_departments do |t|
      t.references :demand
      t.references :department

      t.timestamps
    end
    add_index :compras_demand_departments, :demand_id
    add_foreign_key :compras_demand_departments,
                    :compras_demands,:column => :demand_id

    add_index :compras_demand_departments, :department_id
    add_foreign_key :compras_demand_departments,
                    :compras_departments,:column => :department_id
  end
end