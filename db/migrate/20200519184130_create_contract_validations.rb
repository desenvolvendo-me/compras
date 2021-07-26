class CreateContractValidations < ActiveRecord::Migration
  def change
    create_table :compras_contract_validations do |t|
      t.boolean :blocked
      t.date :date
      t.integer :responsible_id
      t.integer :contract_id
      t.text :observation

      t.timestamps
    end
  end
end
