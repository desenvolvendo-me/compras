class AddDismissChargesWhenClosingToEconomicRegistrationSetting < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :dismiss_charges_when_closing, :boolean, :default => false
  end
end
