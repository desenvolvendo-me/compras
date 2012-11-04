class TradingItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end
end
