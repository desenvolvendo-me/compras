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
end
