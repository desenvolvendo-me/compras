class UseFieldTypeEnumerationOnEconomicPropertySettings < ActiveRecord::Migration
  def change
    remove_column :economic_property_settings, :field_type_id
    add_column :economic_property_settings, :field_type, :string
  end
end
