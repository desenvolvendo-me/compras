class RemovePaymentStateIdFromPayments < ActiveRecord::Migration
  def change
    remove_index :payments, :payment_state_id
    remove_foreign_key :payments, :payment_states
    remove_column :payments, :payment_state_id
  end
end
