class ChangeCanUpdateDueDatesDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :can_update_due_dates, false
  end

  def down
    change_column_default :parcel_debt_settings, :can_update_due_dates, nil
  end
end
