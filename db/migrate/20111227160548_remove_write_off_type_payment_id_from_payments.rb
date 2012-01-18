class RemoveWriteOffTypePaymentIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :write_off_type_payment_id
  end
end
