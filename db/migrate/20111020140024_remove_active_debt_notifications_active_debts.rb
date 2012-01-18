class RemoveActiveDebtNotificationsActiveDebts < ActiveRecord::Migration
  def change
    remove_foreign_key :active_debt_notifications_active_debts, :name => :active_debt_notifications_fk
    remove_foreign_key :active_debt_notifications_active_debts, :name => :active_debts_notification_fk
    remove_index :active_debt_notifications_active_debts, :name => :active_debt_notification
    remove_index :active_debt_notifications_active_debts, :name => :notification_active_debt
    drop_table :active_debt_notifications_active_debts
  end
end
