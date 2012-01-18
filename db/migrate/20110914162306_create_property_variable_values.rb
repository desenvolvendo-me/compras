class CreatePropertyVariableValues < ActiveRecord::Migration
  def change
    create_table :property_variable_values do |t|
      t.references :property
      t.references :property_variable_setting
      t.string :value

      t.timestamps
    end
    add_index :property_variable_values, :property_id
    add_index :property_variable_values, :property_variable_setting_id
    add_foreign_key :property_variable_values, :properties
    add_foreign_key :property_variable_values, :property_variable_settings
  end
end
