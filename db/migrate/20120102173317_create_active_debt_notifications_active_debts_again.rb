class CreateActiveDebtNotificationsActiveDebtsAgain < ActiveRecord::Migration
  def change
    create_table :active_debt_notifications_active_debts, :id => false do |t|
      t.integer :active_debt_notification_id
      t.integer :active_debt_id
    end

    add_index :active_debt_notifications_active_debts, :active_debt_notification_id, :name => :adnad_active_debt_notification_id
    add_index :active_debt_notifications_active_debts, :active_debt_id, :name => :adnad_active_debt_id
    add_foreign_key :active_debt_notifications_active_debts, :active_debt_notifications, :name => :adnad_active_debt_notifications_fk
    add_foreign_key :active_debt_notifications_active_debts, :active_debts, :name => :adnad_active_debts_fk
  end
end
