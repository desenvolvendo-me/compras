class RenameDebtDueDateInDelayedActiveDebts < ActiveRecord::Migration
  def change
    rename_column :delayed_active_debts, :debt_due_date, :generation_date
  end
end
