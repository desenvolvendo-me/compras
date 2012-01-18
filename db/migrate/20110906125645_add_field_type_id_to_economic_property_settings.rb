class AddFieldTypeIdToEconomicPropertySettings < ActiveRecord::Migration
  def change
    add_column :economic_property_settings, :field_type_id, :integer
    add_index :economic_property_settings, :field_type_id
    add_foreign_key :economic_property_settings, :field_types
  end
end
