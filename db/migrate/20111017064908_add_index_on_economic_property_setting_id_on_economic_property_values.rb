class AddIndexOnEconomicPropertySettingIdOnEconomicPropertyValues < ActiveRecord::Migration
  def change
    add_index :economic_property_values, :economic_property_setting_id
  end
end
