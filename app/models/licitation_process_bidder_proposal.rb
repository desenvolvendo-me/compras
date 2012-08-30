class LicitationProcessBidderProposal < Compras::Model
  attr_accessible :licitation_process_bidder, :brand, :unit_price,
                  :administrative_process_budget_allocation_item,
                  :administrative_process_budget_allocation_item_id

  has_enumeration_for :situation, :with => SituationOfProposal

  has_one :licitation_process_lot, :through => :administrative_process_budget_allocation_item
  has_many :licitation_process_ratification_items, :dependent => :destroy

  belongs_to :administrative_process_budget_allocation_item
  belongs_to :licitation_process_bidder

  delegate :material, :quantity, :budget_allocation, :to => :administrative_process_budget_allocation_item, :allow_nil => true
  delegate :unit_price, :to => :administrative_process_budget_allocation_item, :allow_nil => true, :prefix => true
  delegate :reference_unit, :description, :code, :to => :material, :allow_nil => true
  delegate :creditor, :to => :licitation_process_bidder, :allow_nil => true

  after_initialize :set_default_values

  scope :by_lot, lambda { |lot_id|
    joins { administrative_process_budget_allocation_item.licitation_process_lot }.
    where { administrative_process_budget_allocation_item.licitation_process_lot.id.eq(lot_id) }
  }

  def self.by_item_order_by_unit_price(item_id)
    where { administrative_process_budget_allocation_item_id.eq(item_id) & unit_price.not_eq(nil)}.
    order {  unit_price }
  end

  def self.by_lot_item_order_by_unit_price(lot_id)
    select { situation }.
    select { licitation_process_bidder.creditor_id }.
    select { sum(unit_price).as(total_value) }.

    joins { licitation_process_bidder }.
    joins { administrative_process_budget_allocation_item.licitation_process_lot }.

    where { administrative_process_budget_allocation_item.licitation_process_lot.id.eq(lot_id) }.

    group { situation }.
    group { licitation_process_bidder.creditor_id }.
    group { administrative_process_budget_allocation_item.licitation_process_lot.id }.

    order { 'total_value' }
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
    return 0 unless quantity && unit_price
    quantity * unit_price
  end

  def unit_price_greater_than_budget_allocation_item_unit_price?
    unit_price > administrative_process_budget_allocation_item_unit_price
  end

  protected

  def set_default_values
    self.situation ||= SituationOfProposal::UNDEFINED
  end
end
