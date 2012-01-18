class RemoveColumnPropertySettingsDisplayDisableProperties < ActiveRecord::Migration
  def change
    remove_column :property_settings, :display_disable_properties
  end
end
