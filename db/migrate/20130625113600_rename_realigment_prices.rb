class RenameRealigmentPrices < ActiveRecord::Migration
  def change
    rename_table :compras_realigment_prices, :compras_realignment_price_items
  end
end
