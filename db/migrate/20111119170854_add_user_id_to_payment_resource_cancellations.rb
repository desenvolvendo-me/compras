class AddUserIdToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :user_id, :integer
    add_index :payment_resource_cancellations, :user_id
    add_foreign_key :payment_resource_cancellations, :users
  end
end
