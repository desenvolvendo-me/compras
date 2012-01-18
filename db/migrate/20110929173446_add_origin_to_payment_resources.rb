class AddOriginToPaymentResources < ActiveRecord::Migration
  def change
    add_column :payment_resources, :origin, :integer
    add_index  :payment_resources, :origin
  end
end
