class DropTableActiveDebtsRevenues < ActiveRecord::Migration
  def change
    drop_table :active_debts_revenues
  end
end
