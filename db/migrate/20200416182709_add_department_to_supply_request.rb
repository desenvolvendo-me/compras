class AddDepartmentToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests,
               :department_id, :integer

    add_index :compras_supply_requests, :department_id

    add_foreign_key :compras_supply_requests,:compras_departments,
                    column: :department_id
  end
end
