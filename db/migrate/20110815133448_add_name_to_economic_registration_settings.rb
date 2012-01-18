class AddNameToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :name, :string
  end
end
