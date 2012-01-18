class ChangeUniquePropertyRegistrationDefaultOnPropertySettings < ActiveRecord::Migration
  def up
    change_column_default :property_settings, :unique_property_registration, false
  end

  def down
    change_column_default :property_settings, :unique_property_registration, nil
  end
end
