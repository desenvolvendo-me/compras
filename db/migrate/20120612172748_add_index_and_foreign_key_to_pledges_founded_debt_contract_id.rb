class AddIndexAndForeignKeyToPledgesFoundedDebtContractId < ActiveRecord::Migration
  def change
    add_index :pledges, :founded_debt_contract_id

    add_foreign_key :pledges, :contracts, :column => :founded_debt_contract_id
  end
end
