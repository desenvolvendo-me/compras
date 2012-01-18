class RemoveFieldTypeIdFromEconomicRegistrationSettings < ActiveRecord::Migration
  def up
    remove_foreign_key :economic_registration_settings, :field_type
    remove_index :economic_registration_settings, :field_type_id
    remove_column :economic_registration_settings, :field_type_id
  end

  def down
    add_column :economic_registration_settings, :field_type_id, :integer
    add_index :economic_registration_settings, :field_type_id
    add_foreign_key :economic_registration_settings, :field_types
  end
end
