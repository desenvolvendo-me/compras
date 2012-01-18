class CreateActiveDebtNotifications < ActiveRecord::Migration
  def change
    create_table :active_debt_notifications do |t|
      t.integer :year
      t.integer :person_id
      t.integer :registrable_id
      t.string  :registrable_type

      t.timestamps
    end

    add_index :active_debt_notifications, :person_id
    add_index :active_debt_notifications, [:registrable_id, :registrable_type], :name => 'notification_registrable'
    add_foreign_key :active_debt_notifications, :people
  end
end
