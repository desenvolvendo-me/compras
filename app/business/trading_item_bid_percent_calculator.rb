class TradingItemBidPercentCalculator
  def initialize(bid, bid_repository = TradingItemBid)
    @bid = bid
    @bid_repository = bid_repository
  end

  def calculate!
    if lowest_proposal > 0
      (bid.amount - lowest_proposal) / lowest_proposal * BigDecimal(100)
    else
      BigDecimal(0)
    end
  end

  private

  attr_reader :bid, :bid_repository

  def lowest_proposal
    if bid.proposals?
      bid_repository.lowest_proposal_by_item_at_stage_of_proposals(trading_item_id)
    elsif bid.round_of_bids?
      bid_repository.lowest_proposal_by_item_and_round(trading_item_id, bid_round)
    elsif bid.negotiation?
      bid_repository.lowest_proposal_by_item_at_stage_of_negotiation(trading_item_id)
    else
      raise "TradingItemBidPercentCalculator error: stage of bid #{bid} is not include in (proposals, round_of_bids, negotiation)"
    end
  end

  def bid_round
    bid.with_proposal? ? bid.round : bid_repository.bids_by_bidder_and_item(bidder_id, trading_item_id).maximum(:round)
  end

  def trading_item_id
    bid.trading_item_id
  end

  def bidder_id
    bid.bidder_id
  end
end
