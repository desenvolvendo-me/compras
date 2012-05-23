class PriceCollectionProposalItem < ActiveRecord::Base
  attr_accessible :unit_price

  belongs_to :price_collection_proposal
  belongs_to :price_collection_lot_item

  has_one :price_collection_lot, :through => :price_collection_lot_item

  delegate :material, :brand, :reference_unit, :quantity, :to => :price_collection_lot_item, :allow_nil => true

  def total_price
    (unit_price || 0) * (quantity || 0)
  end
end

