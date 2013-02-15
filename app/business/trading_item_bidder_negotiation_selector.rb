class TradingItemBidderNegotiationSelector
  def initialize(trading_item, options = {})
    @trading_item = trading_item
    @preemptive_right = options.fetch(:preemptive_right) { TradingItemPreemptiveRight }
  end

  # Returns all bidders allowed to negotiate. It does not care if bidder already
  # have a negotiation.
  def bidders_selected
    if trading_item.proposals_activated?
      trading_item.enabled_bidders_by_lowest_proposal(:filter => :not_selected)
    else
      if bidder_with_lowest_proposal_benefited? || bidder_with_lowest_proposal.blank?
        bidders_with_preemptive_right
      else
        bidders_with_preemptive_right << bidder_with_lowest_proposal
      end
    end
  end

  # Returns all bidders allowed to negotiate, but remote that ones who already
  # have a negotiation.
  def remaining_bidders
    if allow_negotiation?
      bidders_selected.select { |b| !bidders_with_negotiation_ids.include?(b.id) }
    else
      []
    end
  end

  private

  attr_reader :trading_item

  def bidders
    trading_item.bidders
  end

  def bids
    trading_item.bids
  end

  def bidders_with_negotiation_ids
    bidders.
      with_negotiation_proposal_for(trading_item.id).
      select(:id).
      map(&:id)
  end

  def bidders_ordered_by_offers
    trading_item.enabled_bidders_by_lowest_proposal(:filter => :selected)
  end

  def allow_negotiation?
    bids.with_proposal.at_stage_of_negotiation.empty?
  end

  def bidder_with_lowest_proposal
    trading_item.enabled_bidders_by_lowest_proposal(:filter => :selected).first
  end

  def bidder_with_lowest_proposal_benefited?
    return false unless bidder_with_lowest_proposal

    bidder_with_lowest_proposal.benefited
  end

  def bidders_with_preemptive_right
    TradingItemPreemptiveRight.bidders(trading_item)
  end
end
