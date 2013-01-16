class RemoveOrderFromTradingItems < ActiveRecord::Migration
  def change
    remove_column :compras_trading_items, :order
  end
end
