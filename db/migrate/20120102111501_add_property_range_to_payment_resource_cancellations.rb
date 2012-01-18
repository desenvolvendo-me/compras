class AddPropertyRangeToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :property_range, :string
  end
end
