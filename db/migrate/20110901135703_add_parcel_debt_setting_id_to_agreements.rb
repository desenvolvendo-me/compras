class AddParcelDebtSettingIdToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :parcel_debt_setting_id, :integer
    add_index :agreements, :parcel_debt_setting_id
    add_foreign_key :agreements, :parcel_debt_settings
  end
end
