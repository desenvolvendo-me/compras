class PriceCollectionProposalItemDecorator < Decorator
  def total_price
    helpers.number_with_precision component.total_price
  end
end
