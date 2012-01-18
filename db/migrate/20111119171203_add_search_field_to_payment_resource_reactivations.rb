class AddSearchFieldToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :search_field, :string
  end
end
