class RemoveColumnPropertySettingsUniquePropertyRegistration < ActiveRecord::Migration
  def change
    remove_column :property_settings, :unique_property_registration
  end
end
