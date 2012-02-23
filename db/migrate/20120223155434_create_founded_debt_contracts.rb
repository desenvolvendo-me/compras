class CreateFoundedDebtContracts < ActiveRecord::Migration
  def change
    create_table :founded_debt_contracts do |t|
      t.integer :year
      t.integer :entity_id
      t.string :contract_number
      t.string :process_number
      t.date :signed_date
      t.date :end_date
      t.text :description

      t.timestamps
    end

    add_index :founded_debt_contracts, :entity_id
    add_foreign_key :founded_debt_contracts, :entities
  end
end
