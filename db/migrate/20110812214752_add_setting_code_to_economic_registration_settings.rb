class AddSettingCodeToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :setting_code, :string
  end
end
