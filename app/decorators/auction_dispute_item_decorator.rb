class AuctionDisputeItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  def lowest_proposal_amount
    return '-' unless lowest_item_proposal

    number_with_precision lowest_item_proposal.unit_price
  end

  def lowest_proposal_creditor
    return '-' unless lowest_item_proposal

    number_with_precision lowest_item_proposal.creditor
  end

  def lowest_bid_amount
    return '-' unless lowest_bid.present?

    number_with_precision lowest_bid.amount
  end

  def lowest_bid_creditor
    return '-' unless lowest_bid.present?

    lowest_bid.creditor
  end

  def bids_finished?
    bids.all?(:closed?) if bids.present?
  end
end
