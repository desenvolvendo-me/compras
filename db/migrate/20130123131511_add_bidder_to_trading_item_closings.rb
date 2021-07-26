class AddBidderToTradingItemClosings < ActiveRecord::Migration
  def change
    add_column :compras_trading_item_closings, :bidder_id, :integer

    add_index :compras_trading_item_closings, :bidder_id
    add_foreign_key :compras_trading_item_closings, :compras_bidders, :column => :bidder_id
  end
end
