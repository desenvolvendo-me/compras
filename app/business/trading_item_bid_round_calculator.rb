class TradingItemBidRoundCalculator
  attr_accessor :trading_item

  delegate :trading_item_bids, :available_bidders, :last_bid_round, :to => :trading_item

  def initialize(trading_item)
    self.trading_item = trading_item
  end

  def calculate
    return last_bid_round unless all_bidders_have_bid_for_last_round?

    last_bid_round.succ
  end

  private

  def count_bids_for_last_round
    trading_item_bids.at_round(last_bid_round).count
  end

  def all_bidders_have_bid_for_last_round?
    last_bid_round == 0 || count_bids_for_last_round == available_bidders.count
  end
end
