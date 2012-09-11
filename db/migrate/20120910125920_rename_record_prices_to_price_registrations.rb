class RenameRecordPricesToPriceRegistrations < ActiveRecord::Migration
  def change
    rename_table :compras_record_prices, :compras_price_registrations
  end
end
