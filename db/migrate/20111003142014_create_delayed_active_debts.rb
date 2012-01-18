class CreateDelayedActiveDebts < ActiveRecord::Migration
  def change
    create_table :delayed_active_debts do |t|
      t.string :year
      t.string :person_ids
      t.string :date_values
      t.integer :user_id

      t.timestamps
    end

    add_foreign_key :delayed_active_debts, :users
  end
end
