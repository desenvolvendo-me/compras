class AddRevenueIdToPaymentResources < ActiveRecord::Migration
  def change
    add_column :payment_resources, :revenue_id, :integer
    add_index :payment_resources, :revenue_id
    add_foreign_key :payment_resources, :revenues
  end
end
