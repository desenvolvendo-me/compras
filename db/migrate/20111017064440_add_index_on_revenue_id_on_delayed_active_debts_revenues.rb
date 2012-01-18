class AddIndexOnRevenueIdOnDelayedActiveDebtsRevenues < ActiveRecord::Migration
  def change
    add_index :delayed_active_debts_revenues, :revenue_id
  end
end
