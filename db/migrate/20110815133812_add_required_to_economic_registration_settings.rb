class AddRequiredToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :required, :boolean
  end
end
