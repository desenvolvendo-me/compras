class PriceCollectionProposalItem < ActiveRecord::Base
  attr_accessible :price_collection_proposal_id, :price_collection_lot_item_id, :unit_price

  attr_readonly :price_collection_proposal_id, :price_collection_lot_item_id

  belongs_to :price_collection_proposal
  belongs_to :price_collection_lot_item

  has_one :price_collection_lot, :through => :price_collection_lot_item

  delegate :material, :brand, :reference_unit, :quantity, :to => :price_collection_lot_item, :allow_nil => true

  def total_price
    (unit_price || 0) * (quantity || 0)
  end

  def self.by_proposal_and_item(params = {})
    where { price_collection_proposal_id.eq(params.fetch(:proposal_id)) &
            price_collection_lot_item_id.eq(params.fetch(:item_id)) }
  end
end

