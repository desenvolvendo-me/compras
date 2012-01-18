class ChangeInterestFinancingDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :interest_financing, false
  end

  def down
    change_column_default :parcel_debt_settings, :interest_financing, nil
  end
end
