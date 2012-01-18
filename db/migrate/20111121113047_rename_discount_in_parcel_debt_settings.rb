class RenameDiscountInParcelDebtSettings < ActiveRecord::Migration
  def change
    rename_column :parcel_debt_settings, :discount_id, :tribute_discount_id
  end
end
