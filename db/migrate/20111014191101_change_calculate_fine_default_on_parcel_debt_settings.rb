class ChangeCalculateFineDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :calculate_fine, false
  end

  def down
    change_column_default :parcel_debt_settings, :calculate_fine, nil
  end
end
