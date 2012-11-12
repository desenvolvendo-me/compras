class PriceCollectionProposalItem < Compras::Model
  attr_accessible :price_collection_proposal_id, :price_collection_lot_item_id, :unit_price

  attr_readonly :price_collection_proposal_id, :price_collection_lot_item_id

  belongs_to :price_collection_proposal
  belongs_to :price_collection_lot_item

  has_one :price_collection_lot, :through => :price_collection_lot_item

  delegate :material, :brand, :reference_unit, :quantity, :to => :price_collection_lot_item, :allow_nil => true
  delegate :creditor, :editable_by?, :price_collection, :to => :price_collection_proposal, :allow_nil => true

  scope :by_lot, lambda { |lot_id|
    where { price_collection_lot_item_id.eq(lot_id) }
  }

  def total_price
    unit_price * (quantity || BigDecimal(0))
  end

  def self.by_proposal_and_item(params = {})
    where { price_collection_proposal_id.eq(params.fetch(:proposal_id)) &
            price_collection_lot_item_id.eq(params.fetch(:item_id)) }
  end

  def self.by_item_order_by_unit_price(item_id)
    joins { price_collection_proposal }.
    where { price_collection_lot_item_id.eq(item_id) &
            price_collection_proposal.status.not_eq(PriceCollectionStatus::ANNULLED) &
            unit_price.not_eq(nil)}.
    order { unit_price }
  end

  def self.by_lot_item_order_by_unit_price(lot_id)
    select { price_collection_proposal.creditor_id }.
    select { sum(unit_price).as(total_value) }.

    joins { price_collection_lot_item.price_collection_lot }.
    joins { price_collection_proposal }.

    where { price_collection_lot_item.price_collection_lot_id.eq(lot_id) &
            price_collection_proposal.status.not_eq(PriceCollectionStatus::ANNULLED) }.

    group { price_collection_proposal.creditor_id }.
    group { price_collection_lot_item.price_collection_lot_id }.

    order { 'total_value' }
  end

  def self.any_without_unit_price?(lot = nil)
    query = scoped
    query = query.by_lot(lot.id) if lot
    query = query.where { unit_price.eq(0) }

    query.any?
  end
end
