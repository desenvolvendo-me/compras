class RemovePaymentTypeIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :payment_type_id
  end
end
