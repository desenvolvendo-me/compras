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
    bidders_available - bidders_at_bid_round
  end

  def current_round(round_calculator = TradingItemBidRoundCalculator)
    round_calculator.new(trading_item).calculate
  end

  def bidders_available
    if current_round == 1
      bidders_with_proposal_for_proposal_stage_with_amount_lower_than_limit
    elsif current_round > 1
      bidders_with_proposal_for_round
    else
      bidders
    end
  end

  def bidders_at_bid_round
    bidders.at_bid_round(current_round)
  end

  def bidders_with_proposal_for_round
    bidders.with_proposal_for_trading_item_round(current_round.pred)
  end

  def bidders_with_proposal_for_proposal_stage_with_amount_lower_than_limit
    bidders.with_proposal_for_proposal_stage_with_amount_lower_than_limit(value_limit_to_participate_in_bids)
  end

  def value_limit_to_participate_in_bids
    trading_item.value_limit_to_participate_in_bids
  end
end
