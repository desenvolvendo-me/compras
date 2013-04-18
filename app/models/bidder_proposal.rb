class BidderProposal < Compras::Model
  attr_accessible :bidder, :brand, :unit_price, :purchase_process_item,
                  :purchase_process_item_id

  has_enumeration_for :situation, :with => SituationOfProposal

  has_one :licitation_process_lot, :through => :purchase_process_item
  has_many :licitation_process_ratification_items, :dependent => :destroy

  belongs_to :purchase_process_item
  belongs_to :bidder

  delegate :material, :quantity, :to => :purchase_process_item, :allow_nil => true
  delegate :unit_price, :to => :purchase_process_item, :allow_nil => true, :prefix => true
  delegate :reference_unit, :description, :code, :to => :material, :allow_nil => true
  delegate :creditor, :to => :bidder, :allow_nil => true

  after_initialize :set_default_values

  scope :by_lot, lambda { |lot_id|
    joins { purchase_process_item.licitation_process_lot }.
    where { purchase_process_item.licitation_process_lot.id.eq(lot_id) }
  }

  def self.by_item_order_by_unit_price(item_id)
    where { purchase_process_item_id.eq(item_id) & unit_price.not_eq(nil)}.
    reorder {  unit_price }
  end

  def self.any_without_unit_price?(lot = nil)
    query = scoped
    query = query.by_lot(lot.id) if lot
    query = query.where { unit_price.eq(0) }

    query.any?
  end

  def self.classifications
    LicitationProcessClassification.where do |classification|
      classification.price_collection_proposal_id.in(pluck(:id))
    end
  end

  def total_price
    return BigDecimal(0) unless quantity && unit_price
    quantity * unit_price
  end

  def unit_price_greater_than_budget_allocation_item_unit_price?
    unit_price > purchase_process_item_unit_price
  end

  protected

  def set_default_values
    self.situation ||= SituationOfProposal::UNDEFINED
  end
end
