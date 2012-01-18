class AddFactGeneratableTypeToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :fact_generatable_type, :string
  end
end
