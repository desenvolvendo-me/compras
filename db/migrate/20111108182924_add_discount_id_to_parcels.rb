class AddDiscountIdToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :discount_id, :integer
    add_index  :parcels, :discount_id
    add_foreign_key  :parcels, :discounts
  end
end
