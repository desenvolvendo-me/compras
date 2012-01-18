class DropActiveDebtRevenues < ActiveRecord::Migration
  def change
    drop_table :active_debt_revenues
  end
end
