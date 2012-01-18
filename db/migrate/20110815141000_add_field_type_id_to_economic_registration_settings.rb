class AddFieldTypeIdToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :field_type_id, :integer
    add_index :economic_registration_settings, :field_type_id
    add_foreign_key :economic_registration_settings, :field_types
  end
end
