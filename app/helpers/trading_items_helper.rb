module TradingItemsHelper
  def edit_trading_item_bid_proposal(bidder)
    edit_trading_item_bid_proposal_path(bidder.lower_trading_item_bid(resource),
                                        :trading_item_id => resource.id)
  end
end
