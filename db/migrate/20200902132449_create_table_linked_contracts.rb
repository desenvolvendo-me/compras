class CreateTableLinkedContracts < ActiveRecord::Migration
  def change
    create_table :compras_linked_contracts do |t|
      t.integer :contract_id
      t.string  :contract_number
      t.date    :start_date_contract
      t.date    :end_date_contract
      t.decimal :contract_value, precision: 15, scale: 2
      t.timestamps
    end

    add_index :compras_linked_contracts, :contract_id
    add_foreign_key :compras_linked_contracts, :compras_contracts, column: :contract_id
  end
end
