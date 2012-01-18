class AddStatusToPaymentResources < ActiveRecord::Migration
  def change
    add_column :payment_resources, :status, :integer
    add_index  :payment_resources, :status
  end
end
