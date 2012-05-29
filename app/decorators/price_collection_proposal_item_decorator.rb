class PriceCollectionProposalItemDecorator < Decorator
  def total_price
    helpers.number_with_precision super
  end
end
