class CreateContractDepartments < ActiveRecord::Migration
  def change
    create_table :compras_contract_departments do |t|
      t.integer :contract_id
      t.integer :department_id

      t.timestamps
    end
  end
end
