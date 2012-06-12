class RemoveIndexAndForeignKeyRelatedWithFoundedDebtContracts < ActiveRecord::Migration
  def change
    remove_foreign_key :pledges, :founded_debt_contracts

    remove_index :pledges, :founded_debt_contract_id
  end
end
