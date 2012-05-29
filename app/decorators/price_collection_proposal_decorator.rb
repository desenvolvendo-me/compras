class PriceCollectionProposalDecorator < Decorator
  def price_collection_date
    helpers.l(super) if super
  end

  def item_total_value_by_lot(lot)
    helpers.number_with_precision super(lot)
  end
end
