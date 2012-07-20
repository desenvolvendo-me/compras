# encoding: utf-8
class PriceCollectionClassificationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_value
    number_with_precision super if super
  end

  def total_value
    number_with_precision super if super
  end

  def unit_price_by_proposal(proposal)
    number_with_precision super if super
  end

  def total_value_by_proposal(proposal)
    number_with_precision super if super
  end

  def unit_price_by_price_collection_and_creditor(price_collection, creditor)
    number_with_precision super if super
  end

  def total_value_by_price_collection_and_creditor(price_collection, creditor)
    number_with_precision super if super
  end

  def classification
    I18n.translate((component.classification == 1).to_s)
  end
end
