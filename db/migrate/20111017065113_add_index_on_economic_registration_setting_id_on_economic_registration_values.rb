class AddIndexOnEconomicRegistrationSettingIdOnEconomicRegistrationValues < ActiveRecord::Migration
  def change
    add_index :economic_registration_values, :economic_registration_setting_id, :name => :index_on_economic_registration_setting_id
  end
end
