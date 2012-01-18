class RemoveActiveDebtNotifications < ActiveRecord::Migration
  def change
    remove_foreign_key :active_debt_notifications, :people
    remove_index :active_debt_notifications, :name => :notification_registrable
    remove_index :active_debt_notifications, :person_id
    drop_table :active_debt_notifications
  end
end
