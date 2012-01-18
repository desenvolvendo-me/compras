class RemoveTributeDiscountIdFromParcelDebtSettings < ActiveRecord::Migration
  def change
    remove_column :parcel_debt_settings, :tribute_discount_id
  end
end
