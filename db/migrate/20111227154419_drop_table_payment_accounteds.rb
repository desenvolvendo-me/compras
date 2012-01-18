class DropTablePaymentAccounteds < ActiveRecord::Migration
  def change
    drop_table :payment_accounteds
  end
end
