class TradingItemBidders
  def initialize(trading_item, bidders)
    @trading_item = trading_item
    @bidders = bidders
  end

  def with_proposal_for_proposal_stage_with_amount_lower_than_limit
    bidders.with_proposal_for_proposal_stage_with_amount_lower_than_limit(trading_item)
  end

  def with_proposal_for_proposal_stage_with_amount_lower_than_limit_size
    with_proposal_for_proposal_stage_with_amount_lower_than_limit.size
  end

  def with_proposal_for_round(round)
    bidders.with_proposal_for_trading_item_round(round)
  end

  def at_bid_round(round)
    bidders.at_bid_round(round, trading_item.id)
  end

  def for_stage_of_round_of_bids(round_of_bids = TradingItemBidStage::ROUND_OF_BIDS)
    bidders.at_trading_item_stage(trading_item, round_of_bids)
  end

  private

  attr_reader :trading_item, :bidders
end
