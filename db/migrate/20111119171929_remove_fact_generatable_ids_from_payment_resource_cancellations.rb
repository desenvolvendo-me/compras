class RemoveFactGeneratableIdsFromPaymentResourceCancellations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_cancellations, :fact_generatable_ids
  end
end
