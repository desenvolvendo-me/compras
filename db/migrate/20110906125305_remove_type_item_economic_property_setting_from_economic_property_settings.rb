class RemoveTypeItemEconomicPropertySettingFromEconomicPropertySettings < ActiveRecord::Migration
  def change
    remove_index :economic_property_settings, :name => :type_item_economic_param
    remove_foreign_key :economic_property_settings, :name => :type_item_economic_param
    remove_column :economic_property_settings, :type_item_economic_property_setting_id
  end
end