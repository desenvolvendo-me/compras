class TradingItemBidPercentCalculator
  def initialize(bid)
    @bid = bid
  end

  def calculate!
    if lowest_proposal > 0
      (bid_amount - lowest_proposal) / lowest_proposal * BigDecimal(100)
    else
      BigDecimal(0)
    end
  end

  private

  attr_reader :bid

  def lowest_proposal
    if bid.proposals?
      lowest_proposal_by_item_and_round_at_stage_of_proposals
    elsif bid.round_of_bids?
      lowest_proposal_by_item_and_round
    elsif bid.negotiation?
      lowest_proposal_by_item_and_round_at_stage_of_negotiation
    end
  end

  def bid_round
    bid.with_proposal? ? bid.round : bids_by_bidder_and_item.maximum(:round)
  end

  def bid_amount
    bid.with_proposal? ? bid.amount : lowest_proposal_by_item_at_stage_of_round_of_bids
  end

  def bids_by_bidder_and_item
    TradingItemBid.where { |item_bid|
     item_bid.bidder_id.eq(bid.bidder_id) &
     item_bid.trading_item_id.eq(trading_item_id)
    }.with_proposal
  end

  def lowest_proposal_by_item_at_stage_of_round_of_bids
    bids_by_bidder_and_item.at_stage_of_round_of_bids.minimum(:amount)
  end

  def lowest_proposal_by_item_and_round
    TradingItemBid.where { trading_item_id.eq(trading_item_id) }.at_round(bid_round).minimum(:amount)
  end

  def lowest_proposal_by_item_and_round_at_stage_of_negotiation
    TradingItemBid.where { trading_item_id.eq(trading_item_id) }.at_stage_of_negotiation.minimum(:amount)
  end

  def lowest_proposal_by_item_and_round_at_stage_of_proposals
    TradingItemBid.where { trading_item_id.eq(trading_item_id) }.at_stage_of_proposals.minimum(:amount)
  end

  def trading_item_id
    bid.trading_item_id
  end
end
