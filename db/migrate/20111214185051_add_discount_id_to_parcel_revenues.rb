class AddDiscountIdToParcelRevenues < ActiveRecord::Migration
  def change
    add_column :parcel_revenues, :discount_id, :integer
    add_index :parcel_revenues, :discount_id
    add_foreign_key :parcel_revenues, :discounts
  end
end
