class RemovePaymentResourceIdsFromPaymentResourceReactivations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_reactivations, :payment_resource_ids
  end
end
