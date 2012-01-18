class UseFieldTypeEnumerationOnPropertyVariableSettings < ActiveRecord::Migration
  def change
    remove_column :property_variable_settings, :field_type_id
    add_column :property_variable_settings, :field_type, :string
  end
end
