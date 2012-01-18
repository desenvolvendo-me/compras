class AddProportionalInterestToParcelDebtSetting < ActiveRecord::Migration
  def change
    add_column :parcel_debt_settings, :proportional_interest, :boolean
  end
end
