class DropTableWriteOffTypePayments < ActiveRecord::Migration
  def change
    drop_table :write_off_type_payments
  end
end
