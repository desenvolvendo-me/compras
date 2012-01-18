class AddRevenueIdToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :revenue_id, :integer
    add_index :payment_resource_cancellations, :revenue_id
    add_foreign_key :payment_resource_cancellations, :revenues
  end
end
