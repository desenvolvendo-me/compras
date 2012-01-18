class RemoveIdsFromPaymentResourceReactivations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_reactivations, :ids
  end
end
