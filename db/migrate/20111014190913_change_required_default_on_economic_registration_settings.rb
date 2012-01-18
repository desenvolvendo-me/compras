class ChangeRequiredDefaultOnEconomicRegistrationSettings < ActiveRecord::Migration
  def up
    change_column_default :economic_registration_settings, :required, false
  end

  def down
    change_column_default :economic_registration_settings, :required, nil
  end
end
