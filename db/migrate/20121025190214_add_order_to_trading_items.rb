class AddOrderToTradingItems < ActiveRecord::Migration
  def change
    add_column :compras_trading_items, :order, :integer
  end
end
