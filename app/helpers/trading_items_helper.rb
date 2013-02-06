# encoding: utf-8

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

  def negotiation_link(bidder)
    if resource.decorator.current_bidder_for_negotiation?(bidder)
      link_to("Negociar", new_trading_item_bid_negotiation_path(:trading_item_id => resource.id, :bidder_id => bidder.id), :class => "button primary")
    elsif resource.decorator.last_bidder_for_negotiation?(bidder)
      link_to("Refazer neg.", trading_item_bid_negotiation_path(resource.decorator.last_negotiation), :method => 'delete', :class => "button")
    end
  end
end
