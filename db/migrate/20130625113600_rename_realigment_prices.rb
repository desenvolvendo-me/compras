class RenameRealigmentPrices < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_realigment_prices
      rename_table :compras_realigment_prices, :compras_realignment_price_items
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
