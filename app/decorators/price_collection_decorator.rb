# encoding: utf-8
class PriceCollectionDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def all_price_collection_classifications_groupped
    all_price_collection_classifications.group_by(&:price_collection_proposal)
  end
end
