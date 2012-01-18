class AddForeignKeysToPropertyVariableSettings < ActiveRecord::Migration
  def change
    add_foreign_key :property_variable_settings, :field_types
    add_foreign_key :property_variable_settings, :reference_units
    add_foreign_key :property_variable_settings, :properties
  end
end
