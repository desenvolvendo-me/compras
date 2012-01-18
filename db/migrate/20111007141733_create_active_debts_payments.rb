class CreateActiveDebtsPayments < ActiveRecord::Migration
  def change
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
