# encoding: utf-8
class PriceCollectionLotItemDecorator < Decorator
  def unit_price_by_proposal(proposal)
    helpers.number_with_precision super if super
  end

  def total_value_by_proposal(proposal)
    helpers.number_with_precision super if super
  end

  def unit_price_by_price_collection_and_creditor(price_collection, creditor)
    helpers.number_with_precision super if super
  end

  def total_value_by_price_collection_and_creditor(price_collection, creditor)
    helpers.number_with_precision super if super
  end
end
