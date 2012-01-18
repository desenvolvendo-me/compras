class AddRevenueIdToLowerPayments < ActiveRecord::Migration
  def change
    add_column :lower_payments, :revenue_id, :integer
    add_index :lower_payments, :revenue_id
    add_foreign_key :lower_payments, :revenues
  end
end
