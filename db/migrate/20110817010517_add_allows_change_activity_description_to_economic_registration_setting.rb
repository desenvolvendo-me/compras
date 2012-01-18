class AddAllowsChangeActivityDescriptionToEconomicRegistrationSetting < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :allows_change_activity_description, :boolean, :default => false
  end
end
