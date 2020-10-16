class AuctionDisputItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  def lowest_proposal_amount
    return '-' unless lowest_item_proposal_amount

    number_with_precision lowest_item_proposal_amount.unit_price
  end

  def lowest_proposal_creditor
    return '-' unless lowest_item_proposal_amount

    number_with_precision lowest_item_proposal_amount.creditor
  end

  def bids_finished?
    bids.all? {|x| x.closed? } if bids.present?
  end
end
