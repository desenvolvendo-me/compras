class AddEconomicRegistrationRangeToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :economic_registration_range, :string
  end
end
