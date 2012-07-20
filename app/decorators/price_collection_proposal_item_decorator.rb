class PriceCollectionProposalItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def total_price
    number_with_precision super if super
  end

  def unit_price
    number_with_precision super if super
  end
end
