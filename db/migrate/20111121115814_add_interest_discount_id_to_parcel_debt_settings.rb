class AddInterestDiscountIdToParcelDebtSettings < ActiveRecord::Migration
  def change
    add_column :parcel_debt_settings, :interest_discount_id, :integer
    add_index :parcel_debt_settings, :interest_discount_id
    add_foreign_key :parcel_debt_settings, :discounts, :column => :interest_discount_id
  end
end
