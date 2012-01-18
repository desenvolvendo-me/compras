class RemoveFactGeneratableIdsFromPaymentResourceReactivations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_reactivations, :fact_generatable_ids
  end
end
