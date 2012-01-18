class AddPaymentStateToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payment_state, :string
  end
end
