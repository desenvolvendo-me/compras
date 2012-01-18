class ChangeCalculateInterestDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :calculate_interest, false
  end

  def down
    change_column_default :parcel_debt_settings, :calculate_interest, nil
  end
end
