class TradingItemPreemptiveRight
  def initialize(trading_item, percent_limit = BigDecimal('1.05'))
    @trading_item = trading_item
    @percent_limit = percent_limit
  end

  def self.bidders(*params)
    new(*params).bidders_benefited
  end

  def bidders_benefited
    trading_item_bidders.
      enabled.
      benefited.
      under_limit_value(trading_item, limit_value).
      ordered_by_trading_item_bid_amount(trading_item)
  end

  private

  attr_reader :trading_item, :percent_limit

  def bids
    trading_item.bids
  end

  def trading_item_bidders
    trading_item.bidders
  end

  def limit_value
    lowest_proposal_amount_with_valid_proposal * percent_limit
  end

  def lowest_proposal_amount_with_valid_proposal
    if trading_item.proposals_activated?
      bids.with_proposal.exclude_negotiation.minimum(:amount) || BigDecimal("0")
    else
      bids.enabled.exclude_negotiation.with_proposal.minimum(:amount) || BigDecimal("0")
    end
  end
end
