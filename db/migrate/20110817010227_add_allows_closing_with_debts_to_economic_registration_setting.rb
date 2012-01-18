class AddAllowsClosingWithDebtsToEconomicRegistrationSetting < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :allows_closing_with_debts, :boolean, :default => false
  end
end
