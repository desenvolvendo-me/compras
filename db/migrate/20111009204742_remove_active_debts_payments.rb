class RemoveActiveDebtsPayments < ActiveRecord::Migration
  def up
    remove_foreign_key :active_debts_payments, :payments
    remove_foreign_key :active_debts_payments, :active_debts
    remove_index :active_debts_payments, :payment_id
    remove_index :active_debts_payments, :active_debt_id
    drop_table :active_debts_payments
  end

  def down
    create_table :active_debts_payments, :id => false do |t|
      t.integer :active_debt_id
      t.integer :payment_id
    end

    add_index :active_debts_payments, :active_debt_id
    add_index :active_debts_payments, :payment_id
    add_foreign_key :active_debts_payments, :active_debts
    add_foreign_key :active_debts_payments, :payments
  end
end
