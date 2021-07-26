class ChangePrecisionOfPercentTradingItems < ActiveRecord::Migration
  def change
    remove_column :compras_trading_items, :minimum_reduction_percent

    add_column :compras_trading_items, :minimum_reduction_percent, :decimal,
               :precision => 5, :scale => 2, :default => 0.0
  end
end
