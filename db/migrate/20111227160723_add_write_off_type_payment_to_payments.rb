class AddWriteOffTypePaymentToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :write_off_type_payment, :string
  end
end
