class CreateDebtPaymentResourcesLowerPayments < ActiveRecord::Migration
  def change
    create_table :debt_payment_resources_lower_payments, :id => false do |t|
      t.integer :lower_payment_id
      t.integer :debt_payment_resource_id
    end

    add_index :debt_payment_resources_lower_payments, :lower_payment_id, :name => :dprlp_lower_payment_id
    add_index :debt_payment_resources_lower_payments, :debt_payment_resource_id, :name => :dprlp_debt_payment_resource_id
    add_foreign_key :debt_payment_resources_lower_payments, :lower_payments, :name => :dprlp_lower_payments
    add_foreign_key :debt_payment_resources_lower_payments, :debt_payment_resources, :name => :dprlp_debt_payment_resources
  end
end
