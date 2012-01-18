class AddSettingPropertyIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :property_setting_id, :integer
    add_index :fields, :property_setting_id
    add_foreign_key :fields, :property_settings
  end
end
