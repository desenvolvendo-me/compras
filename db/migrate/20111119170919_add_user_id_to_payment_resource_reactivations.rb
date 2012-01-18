class AddUserIdToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :user_id, :integer
    add_index :payment_resource_reactivations, :user_id
    add_foreign_key :payment_resource_reactivations, :users
  end
end
