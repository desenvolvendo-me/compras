class RemovePaymentResourceIdsFromPaymentResourceCancellations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_cancellations, :payment_resource_ids
  end
end
