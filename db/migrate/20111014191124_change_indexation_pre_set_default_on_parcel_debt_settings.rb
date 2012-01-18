class ChangeIndexationPreSetDefaultOnParcelDebtSettings < ActiveRecord::Migration
  def up
    change_column_default :parcel_debt_settings, :indexation_pre_set, false
  end

  def down
    change_column_default :parcel_debt_settings, :indexation_pre_set, nil
  end
end
