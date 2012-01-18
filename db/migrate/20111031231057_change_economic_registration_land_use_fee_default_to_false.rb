class ChangeEconomicRegistrationLandUseFeeDefaultToFalse < ActiveRecord::Migration
  def up
    change_column_default :economic_registrations, :land_use_fee, false
  end

  def down
    change_column_default :economic_registrations, :land_use_fee, true
  end
end
