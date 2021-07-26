class AddDiscountToRealignmentPrices < ActiveRecord::Migration
  def change
    add_column :compras_realignment_prices, :discount, :decimal, precision: 10, scale: 2
  end
end
