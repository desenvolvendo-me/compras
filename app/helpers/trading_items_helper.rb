module TradingItemsHelper
  def new_trading_item_bid_round_of_bid_with_anchor
    new_trading_item_bid_round_of_bid_path(:trading_item_id => resource.id, :anchor => :title)
  end

  def edit_trading_item_bid_proposal(bidder)
    edit_trading_item_bid_proposal_path(bidder.lower_trading_item_bid(resource),
                                        :trading_item_id => resource.id,
                                        :anchor => :title)
  end
end
