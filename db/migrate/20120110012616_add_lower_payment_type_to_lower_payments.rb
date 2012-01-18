class AddLowerPaymentTypeToLowerPayments < ActiveRecord::Migration
  def change
    add_column :lower_payments, :lower_payment_type, :string
  end
end
