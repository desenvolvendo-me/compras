class AddEconomicRegistrationRangeToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :economic_registration_range, :string
  end
end
