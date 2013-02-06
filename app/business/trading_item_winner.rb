class TradingItemWinner
  def initialize(trading_item, options = {})
    @trading_item = trading_item
    @preemptive_right = options.fetch(:preemptive_right) { TradingItemPreemptiveRight.bidders(trading_item) }
  end

  def self.winner(*params)
    new(*params).bidder_winner
  end

  def bidder_winner
    if lowest_proposal_is_winner?
      bidder_of_lowest_bid
    end
  end

  private

  attr_reader :trading_item, :preemptive_right

  def bids
    trading_item.bids
  end

  def lowest_bid
    bids.last_valid_proposal
  end

  def bidder_of_lowest_bid
    return unless lowest_bid

    lowest_bid.bidder
  end

  def lowest_proposal_is_winner?
    return unless lowest_bid

    lowest_bid.negotiation? || bidder_valid?
  end

  def bidder_valid?
    return unless bidder_of_lowest_bid

    !bidder_of_lowest_bid.disabled && !bidder_of_lowest_bid.benefited && preemptive_right.empty? && !bidder_have_negotiation_without_proposal?
  end

  def bidder_have_negotiation_without_proposal?
    bids.
      at_stage_of_negotiation.
      with_no_proposal.
      map(&:bidder).
      include?(bidder_of_lowest_bid)
  end
end
