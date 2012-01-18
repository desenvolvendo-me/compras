class AddSearchFieldToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :search_field, :string
  end
end
