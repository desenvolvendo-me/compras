class PurchaseProcessTradingItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def lowest_bid_amount
    return '-' unless lowest_bid.present?

    number_with_precision lowest_bid.amount
  end

  def lowest_bid_creditor
    return '-' unless lowest_bid.present?

    lowest_bid.accreditation_creditor
  end

  def lowest_proposal_amount
    return '-' unless lowest_proposal

    number_with_precision lowest_proposal.unit_price
  end

  def lowest_proposal_creditor
    return '-' unless lowest_proposal

    lowest_proposal.creditor
  end
end
