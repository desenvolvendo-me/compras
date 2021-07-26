class PurchaseProcessTradingItemNegotiationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def amount
    number_to_currency super if super
  end
end
