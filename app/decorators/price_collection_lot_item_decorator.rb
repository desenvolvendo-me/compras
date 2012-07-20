# encoding: utf-8
class PriceCollectionLotItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price_by_price_collection_and_creditor(price_collection, creditor)
    number_with_precision super if super
  end

  def total_value_by_price_collection_and_creditor(price_collection, creditor)
    number_with_precision super if super
  end
end
