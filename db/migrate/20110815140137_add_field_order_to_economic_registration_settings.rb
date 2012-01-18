class AddFieldOrderToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :field_order, :integer
  end
end
