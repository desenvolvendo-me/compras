class ChangeDisplayDisablePropertiesDefaultOnPropertySettings < ActiveRecord::Migration
  def up
    change_column_default :property_settings, :display_disable_properties, false
  end

  def down
    change_column_default :property_settings, :display_disable_properties, nil
  end
end
