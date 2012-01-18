class AddFieldTypeToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :field_type, :string
  end
end
