class AddDebtPaymentResourceIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :debt_payment_resource_id, :integer
    add_index :payments, :debt_payment_resource_id
    add_foreign_key :payments, :debt_payment_resources
  end
end
