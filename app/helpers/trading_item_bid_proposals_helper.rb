module TradingItemBidProposalsHelper
  def back_link_path(trading_item = @parent)
    if resource.persisted?
      proposal_report_trading_item_path(trading_item)
    else
      trading_items_path(:trading_id => trading_item.trading_id)
    end
  end
end
