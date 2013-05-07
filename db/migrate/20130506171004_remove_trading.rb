class RemoveTrading < ActiveRecord::Migration
  def change
    drop_table :compras_trading_item_bids
    drop_table :compras_trading_item_closings
    drop_table :compras_trading_items
    drop_table :compras_trading_closings
    drop_table :compras_tradings
    drop_table :compras_trading_configurations
    drop_table :compras_bidder_disqualifications
  end
end
