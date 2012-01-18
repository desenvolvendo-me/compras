class AddYearToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :year, :integer
  end
end
