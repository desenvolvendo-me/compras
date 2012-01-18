class CreateActiveDebtsDebtPaymentResources < ActiveRecord::Migration
  def change
    create_table :active_debts_debt_payment_resources, :id => false do |t|
      t.integer :active_debt_id
      t.integer :debt_payment_resource_id
    end

    add_index :active_debts_debt_payment_resources, :active_debt_id
    add_index :active_debts_debt_payment_resources, :debt_payment_resource_id, :name => 'active_debt_payment_resource_id'
    add_foreign_key :active_debts_debt_payment_resources, :active_debts
    add_foreign_key :active_debts_debt_payment_resources, :debt_payment_resources
  end
end
