class CreatePropertyVariableSettingOptions < ActiveRecord::Migration
  def change
    create_table :property_variable_setting_options do |t|
      t.string :name
      t.integer :property_variable_setting_id
      
      t.timestamps
    end
    add_index :property_variable_setting_options, :property_variable_setting_id, :name => 'index_property_variable_options_on_property_variable_setting'
    add_foreign_key :property_variable_setting_options, :property_variable_settings, :column => :property_variable_setting_id, :name => 'fk_property_variable_options_on_property_variable_setting'
  end
end
