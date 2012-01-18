class CreateEconomicRegistrationValues < ActiveRecord::Migration
  def change
    create_table :economic_registration_values do |t|
      t.integer :economic_registration_id
      t.integer :economic_registration_setting_id
      t.string :value

      t.timestamps
    end
    add_foreign_key :economic_registration_values, :economic_registrations, :name => :erv_economic_registrations
    add_foreign_key :economic_registration_values, :economic_registration_settings, :name => :erv_economic_registration_settings
  end
end
