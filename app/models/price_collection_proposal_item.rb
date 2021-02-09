class PriceCollectionProposalItem < Compras::Model
  attr_accessible :price_collection_proposal_id, :price_collection_item_id, :unit_price

  attr_readonly :price_collection_proposal_id, :price_collection_item_id

  belongs_to :price_collection_proposal
  belongs_to :price_collection_item

  has_one :price_collection, through: :price_collection_proposal

  delegate :material, :brand, :reference_unit, :quantity, :lot,
    to: :price_collection_item, allow_nil: true
  delegate :creditor, :editable_by?, :price_collection,
    to: :price_collection_proposal, allow_nil: true

  scope :by_lot, lambda { |lot|
    joins { price_collection_item }.
    where { price_collection_item.lot.eq(lot) }
  }

  scope :ranked_by_unit_price, lambda {
    where { unit_price.gt(0) }.
    order { unit_price }
  }

  def total_price
    (unit_price * (quantity || BigDecimal(0))).round(3)
  end

  def self.by_proposal_and_item(params = {})
    where { price_collection_proposal_id.eq(params.fetch(:proposal_id)) &
            price_collection_item_id.eq(params.fetch(:item_id)) }
  end

  def self.by_item_order_by_unit_price(item_id)
    joins { price_collection_proposal }.
    where { price_collection_item_id.eq(item_id) &
            unit_price.not_eq(nil)}.
    where("compras_price_collection_proposals.status IS DISTINCT FROM (?)", PriceCollectionStatus::ANNULLED).
    order{ unit_price }
  end

  def self.by_lot_item_order_by_unit_price(lot, proposals_ids)
    select { price_collection_proposal.creditor_id }.
    select { sum(unit_price).as(total_value) }.

    joins { price_collection_proposal }.
    joins { price_collection_item }.

    where { price_collection_item.lot.eq(lot)}.
    where("compras_price_collection_proposals.status IS DISTINCT FROM (?)", PriceCollectionStatus::ANNULLED).
    where("compras_price_collection_proposals.id IN (?)", proposals_ids).
    group { price_collection_proposal.creditor_id }.
    group { price_collection_item.lot }.

    order { 'total_value' }
  end

  def self.any_without_unit_price?(lot = nil)
    query = scoped
    query = query.by_lot(lot) if lot
    query = query.where { unit_price.eq(0) }

    query.any?
  end
end
