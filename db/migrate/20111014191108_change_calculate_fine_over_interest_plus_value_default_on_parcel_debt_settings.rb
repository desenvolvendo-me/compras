class ChangeCalculateFineOverInterestPlusValueDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :calculate_fine_over_interest_plus_value, false
  end

  def down
    change_column_default :parcel_debt_settings, :calculate_fine_over_interest_plus_value, nil
  end
end
