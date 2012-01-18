class AddPropertyRangeToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :property_range, :string
  end
end
