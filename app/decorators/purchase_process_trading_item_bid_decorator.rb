class PurchaseProcessTradingItemBidDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def percent
    return '-' unless super

    number_with_precision super
  end
end
