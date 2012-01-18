class AddYearToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :year, :integer
  end
end
