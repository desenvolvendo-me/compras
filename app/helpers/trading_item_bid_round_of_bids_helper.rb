module TradingItemBidRoundOfBidsHelper
  def destroy_last_bid_path(trading_item)
    trading_item_bid_round_of_bid_path(trading_item.last_bid, :trading_item_id => trading_item.id)
  end
end
