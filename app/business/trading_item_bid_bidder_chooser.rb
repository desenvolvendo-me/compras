class TradingItemBidBidderChooser
  attr_accessor :trading_item

  delegate :bidders, :to => :trading_item

  def initialize(trading_item)
    self.trading_item = trading_item
  end

  def choose
    bidders_available_for_current_round.first
  end

  private

  def bidders_available_for_current_round
    bidders_available(current_round.pred) - bidders_at_bid_round(current_round)
  end

  def current_round(round_calculator = TradingItemBidRoundCalculator)
    round_calculator.new(trading_item).calculate
  end

  def bidders_available(round)
    if round > 0
      bidders_with_proposal_for_round(round)
    else
      bidders
    end
  end

  def bidders_at_bid_round(round)
    bidders.at_bid_round(current_round)
  end

  def bidders_with_proposal_for_round(round)
    bidders.with_proposal_for_trading_item_round(round)
  end
end
