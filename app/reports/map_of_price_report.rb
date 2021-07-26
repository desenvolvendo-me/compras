class MapOfPriceReport < Report
  include Decore::Infection

  attr_accessor :price_collection_id

  def item_proposals_grouped_by_lot
    records.group_by { |item| lot_group(item) } if records
  end

  def price_collection
    records.first.try(:price_collection)
  end

  protected

  def lot_group(item)
    "#{item.lot} - #{item.material}"
  end

  def normalize_attributes
    { :price_collection => price_collection_id }
  end
end
