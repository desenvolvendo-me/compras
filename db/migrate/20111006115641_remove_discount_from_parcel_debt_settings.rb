class RemoveDiscountFromParcelDebtSettings < ActiveRecord::Migration
  def up
    remove_column :parcel_debt_settings, :discount
  end

  def down
    add_column :parcel_debt_settings, :discount, :boolean
  end
end
