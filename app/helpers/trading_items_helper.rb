module TradingItemsHelper
  def edit_trading_item_bid_proposal(bidder)
    edit_trading_item_bid_proposal_path(bidder.last_bid(resource),
                                        :trading_item_id => resource.id)
  end

  def trading_item_closing_path(trading_item = resource)
    if trading_item.closed?
      edit_trading_item_closing_path(trading_item.closing)
    else
      new_trading_item_closing_path(:trading_item_id => trading_item.id)
    end
  end
end
