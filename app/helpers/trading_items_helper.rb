module TradingItemsHelper
  def new_trading_item_bid_with_anchor
    new_trading_item_bid_path(:trading_item_id => resource.id, :anchor => :title)
  end
end
