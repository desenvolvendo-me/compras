class AddReductionsDefaultValueToPurchaseProcessTradingItems < ActiveRecord::Migration
  def change
    change_column :compras_purchase_process_trading_items, :reduction_rate_value, :decimal, :precision => 10, :scale => 2, default: 0.0
    change_column :compras_purchase_process_trading_items, :reduction_rate_percent, :decimal, :precision => 10, :scale => 2, default: 0.0

    execute <<-SQL
      UPDATE compras_purchase_process_trading_items
      SET reduction_rate_value = 0.0, reduction_rate_percent = 0.0
    SQL
  end
end
