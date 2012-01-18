class AddDiscountIdToParcelDebtSettings < ActiveRecord::Migration
  def change
    add_column :parcel_debt_settings, :discount_id, :integer
    add_index :parcel_debt_settings, :discount_id
    add_foreign_key :parcel_debt_settings, :discounts
  end
end
