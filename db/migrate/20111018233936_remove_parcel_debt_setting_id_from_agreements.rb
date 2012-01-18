class RemoveParcelDebtSettingIdFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :parcel_debt_setting_id
  end
end
