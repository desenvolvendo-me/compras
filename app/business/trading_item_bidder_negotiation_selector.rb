class TradingItemBidderNegotiationSelector
  def initialize(trading_item)
    @trading_item = trading_item
  end

  # Returns all bidders allowed to negotiate. It does not care if bidder already
  # have a negotiation.
  def bidders_selected
    if trading_item.proposals_activated?
      trading_item.enabled_bidders_by_lowest_proposal(:filter => :not_selected)
    else
      bidders_benefited
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

  def limit_value
    lowest_proposal_amount_with_valid_proposal * BigDecimal("1.05")
  end

  def lowest_proposal_amount_with_valid_proposal
    if trading_item.proposals_activated?
      bids.with_proposal.exclude_negotiation.minimum(:amount)
    else
      bids.enabled.exclude_negotiation.with_proposal.minimum(:amount)
    end
  end

  def bidders_with_negotiation_ids
    bidders.with_negotiation_proposal_for(trading_item.id).select(:id).map(&:id)
  end

  def bidders_benefited
    bidders.
      enabled.
      benefited.
      under_limit_value(trading_item, limit_value).
      ordered_by_trading_item_bid_amount(trading_item)
  end

  def bidders_ordered_by_offers
    trading_item.enabled_bidders_by_lowest_proposal(:filter => :selected)
  end

  def allow_negotiation?
    bids.with_proposal.at_stage_of_negotiation.empty?
  end
end
