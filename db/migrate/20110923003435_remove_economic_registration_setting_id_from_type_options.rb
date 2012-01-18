class RemoveEconomicRegistrationSettingIdFromTypeOptions < ActiveRecord::Migration
  def up
    remove_foreign_key :type_options, :economic_registration_settings
    remove_index :type_options, :economic_registration_setting_id
    remove_column :type_options, :economic_registration_setting_id
  end

  def down
    add_column :type_options, :economic_registration_setting_id, :integer
    add_index :type_options, :economic_registration_setting_id
    add_foreign_key :type_options, :economic_registration_settings
  end
end
