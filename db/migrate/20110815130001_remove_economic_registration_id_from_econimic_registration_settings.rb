class RemoveEconomicRegistrationIdFromEconimicRegistrationSettings < ActiveRecord::Migration
  def up
    remove_index :economic_registration_settings, :name => "economic_registration_idx"
    remove_foreign_key :economic_registration_settings, :name => "economic_registration_settins_fk"
    remove_column :economic_registration_settings, :economic_registration_id
  end

  def down
    add_column :economic_registration_settings, :economic_registration_id, :integer
    add_index :economic_registration_settings, :economic_registration_id, :name => "economic_registration_idx"
    add_foreign_key :economic_registration_settings, :economic_registrations, :name => "economic_registration_settins_fk"
  end
end
