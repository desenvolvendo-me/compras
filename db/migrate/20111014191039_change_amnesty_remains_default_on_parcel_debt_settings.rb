class ChangeAmnestyRemainsDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :amnesty_remains, false
  end

  def down
    change_column_default :parcel_debt_settings, :amnesty_remains, nil
  end
end
