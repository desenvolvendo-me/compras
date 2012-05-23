class PriceCollectionProposalDecorator < Decorator
  def price_collection_date
    helpers.l(component.price_collection_date) if component.price_collection_date
  end

  def item_total_value_by_lot(lot)
    helpers.number_with_precision component.item_total_value_by_lot(lot)
  end
end
