class AddMissingColumnsToLowerPayment < ActiveRecord::Migration
  def change
    add_column :lower_payments, :payment_date, :date
    add_column :lower_payments, :payment_type, :string
    add_column :lower_payments, :total_amount, :decimal, :precision => 10, :scale => 2
  end
end
