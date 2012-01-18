class AddIndexOnDelayedActiveDebtIdOnDelayedActiveDebtsRevenues < ActiveRecord::Migration
  def change
    add_index :delayed_active_debts_revenues, :delayed_active_debt_id
  end
end
