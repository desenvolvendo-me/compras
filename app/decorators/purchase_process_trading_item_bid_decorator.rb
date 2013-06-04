class PurchaseProcessTradingItemBidDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def percent
    return '-' unless super

    number_with_precision super
  end

  def amount_with_reduction
    number_with_precision(super) || '0,00'
  end
end
