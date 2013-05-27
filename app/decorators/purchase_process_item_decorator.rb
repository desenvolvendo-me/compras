class PurchaseProcessItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def estimated_total_price
    number_to_currency super if super
  end

  def unit_price
    number_with_precision super if super
  end

  def unit_price_by_bidder(bidder)
    number_with_precision super if super
  end

  def total_value_by_bidder(bidder)
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def lowest_bid_amount
    return '-' unless lowest_trading_bid.present?

    number_with_precision lowest_trading_bid.amount
  end

  def lowest_bid_creditor
    return '-' unless lowest_trading_bid.present?

    lowest_trading_bid.accreditation_creditor
  end

  def lowest_proposal_amount
    return '-' unless trading_lowest_proposal

    number_with_precision trading_lowest_proposal.unit_price
  end

  def lowest_proposal_creditor
    return '-' unless trading_lowest_proposal

    trading_lowest_proposal.creditor
  end
end
