class ChangeDueDateInWeekDaysDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :due_date_in_week_days, false
  end

  def down
    change_column_default :parcel_debt_settings, :due_date_in_week_days, nil
  end
end
