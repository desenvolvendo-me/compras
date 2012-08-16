# encoding: utf-8
class PriceCollectionClassificationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def unit_value
    number_with_precision super if super
  end

  def total_value
    number_with_precision super if super
  end

  def classification
    translate((component.classification == 1).to_s)
  end
end
