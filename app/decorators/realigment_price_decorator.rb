class RealigmentPriceDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def price_with_precision
    number_with_precision price if price
  end

  def total_price
    number_with_precision super if super
  end
end
