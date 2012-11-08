class TradingItemBidBidderChooser
  attr_accessor :trading_item

  def initialize(trading_item)
    self.trading_item = trading_item
  end

  def choose
    trading_item.bidders_available_for_current_round.first
  end
end
