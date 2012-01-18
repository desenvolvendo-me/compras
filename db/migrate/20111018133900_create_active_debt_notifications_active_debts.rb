class CreateActiveDebtNotificationsActiveDebts < ActiveRecord::Migration
  def change
    create_table :active_debt_notifications_active_debts, :id => false do |t|
      t.integer :active_debt_notification_id
      t.integer :active_debt_id
    end

    add_index :active_debt_notifications_active_debts, :active_debt_notification_id, :name => :active_debt_notification
    add_index :active_debt_notifications_active_debts, :active_debt_id, :name => :notification_active_debt
    add_foreign_key :active_debt_notifications_active_debts, :active_debt_notifications, :name => :active_debt_notifications_fk
    add_foreign_key :active_debt_notifications_active_debts, :active_debts, :name => :active_debts_notification_fk
  end
end
