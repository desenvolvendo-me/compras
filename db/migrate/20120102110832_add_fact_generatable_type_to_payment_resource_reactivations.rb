class AddFactGeneratableTypeToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :fact_generatable_type, :string
  end
end
