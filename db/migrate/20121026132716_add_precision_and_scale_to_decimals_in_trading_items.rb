class AddPrecisionAndScaleToDecimalsInTradingItems < ActiveRecord::Migration
  def change
    change_column :compras_trading_items, :minimum_reduction_percent, :decimal,
                  :precision => 10, :scale => 2, :default => 0.0

    change_column :compras_trading_items, :minimum_reduction_value, :decimal,
                  :precision => 10, :scale => 2, :default => 0.0
  end
end
