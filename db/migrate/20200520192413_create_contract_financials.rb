class CreateContractFinancials < ActiveRecord::Migration
  def change
    create_table :compras_contract_financials do |t|
      t.integer :contract_id
      t.integer :expense_id
      t.integer :secretary_id
      t.decimal :value

      t.timestamps
    end
  end
end
