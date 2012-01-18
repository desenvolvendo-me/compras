class RemoveFactGeneratableTypeFromPaymentResourceCancellations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_cancellations, :fact_generatable_type
  end
end
