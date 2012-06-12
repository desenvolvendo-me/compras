class DropFoundedDebtContracts < ActiveRecord::Migration
  def change
    drop_table :founded_debt_contracts
  end
end
