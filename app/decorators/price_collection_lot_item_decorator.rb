# encoding: utf-8
class PriceCollectionLotItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price_by_proposal(price_collection_proposal)
    number_with_precision super if super
  end

  def total_value_by_proposal(price_collection_proposal)
    number_with_precision super if super
  end
end
