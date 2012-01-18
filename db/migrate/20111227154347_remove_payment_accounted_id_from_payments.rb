class RemovePaymentAccountedIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :payment_accounted_id
  end
end
