class RemoveSearchFieldFromPaymentResourceCancellations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_cancellations, :search_field
  end
end
