class AddDebtDueDateToDelayedActiveDebts < ActiveRecord::Migration
  def change
    add_column :delayed_active_debts, :debt_due_date, :date
  end
end
