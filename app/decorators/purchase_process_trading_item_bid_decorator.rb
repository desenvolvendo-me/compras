class PurchaseProcessTradingItemBidDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def percent
    return '-' unless super

    number_with_precision super
  end

  def amount
    number_to_currency super if super
  end

  def amount_with_reduction
    number_with_precision(super) || '0,00'
  end

  def lowest_bid_or_proposal_amount
    number_with_precision super
  end

  def lot
    return super if lot?

    item_item_lot
  end
end
