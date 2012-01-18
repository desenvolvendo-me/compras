class CreateDelayedActiveDebtsRevenues < ActiveRecord::Migration
  def change
    create_table :delayed_active_debts_revenues, :id => false do |t|
      t.integer :delayed_active_debt_id
      t.integer :revenue_id
    end

    add_foreign_key :delayed_active_debts_revenues, :delayed_active_debts
    add_foreign_key :delayed_active_debts_revenues, :revenues
  end
end
