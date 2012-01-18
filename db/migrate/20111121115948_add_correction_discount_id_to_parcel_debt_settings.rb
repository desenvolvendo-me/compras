class AddCorrectionDiscountIdToParcelDebtSettings < ActiveRecord::Migration
  def change
    add_column :parcel_debt_settings, :correction_discount_id, :integer
    add_index :parcel_debt_settings, :correction_discount_id
    add_foreign_key :parcel_debt_settings, :discounts, :column => :correction_discount_id
  end
end
