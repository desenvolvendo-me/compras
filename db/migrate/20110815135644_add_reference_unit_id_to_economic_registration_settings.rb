class AddReferenceUnitIdToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :reference_unit_id, :integer
    add_index :economic_registration_settings, :reference_unit_id
    add_foreign_key :economic_registration_settings, :reference_units
  end
end
