class RemoveIdsFromPaymentResourceCancellations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_cancellations, :ids
  end
end
