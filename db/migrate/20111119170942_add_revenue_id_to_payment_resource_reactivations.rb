class AddRevenueIdToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :revenue_id, :integer
    add_index :payment_resource_reactivations, :revenue_id
    add_foreign_key :payment_resource_reactivations, :revenues
  end
end
