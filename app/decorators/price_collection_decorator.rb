# encoding: utf-8
class PriceCollectionDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def winner_proposal_total_price
    number_with_precision super if super
  end

  def all_price_collection_classifications_groupped
    all_price_collection_classifications.group_by(&:creditor)
  end
end
