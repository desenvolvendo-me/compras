class CreateActiveDebtNotificationsAgain < ActiveRecord::Migration
  def change
    create_table :active_debt_notifications do |t|
      t.string :year
      t.integer :person_id
      t.timestamps
    end

    add_index :active_debt_notifications, :person_id
    add_foreign_key :active_debt_notifications, :people
  end
end
