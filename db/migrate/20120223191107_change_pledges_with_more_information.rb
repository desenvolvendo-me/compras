class ChangePledgesWithMoreInformation < ActiveRecord::Migration
  def change
    change_table :pledges do |t|
      t.integer :reserve_fund_id
      t.string :material_kind
      t.integer :founded_debt_contract_id
      t.integer :creditor_id
    end

    add_index :pledges, :reserve_fund_id
    add_index :pledges, :founded_debt_contract_id
    add_index :pledges, :creditor_id

    add_foreign_key :pledges, :reserve_funds
    add_foreign_key :pledges, :founded_debt_contracts
    add_foreign_key :pledges, :creditors
  end
end
