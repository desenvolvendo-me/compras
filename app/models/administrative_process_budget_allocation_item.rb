class AdministrativeProcessBudgetAllocationItem < Compras::Model
  attr_accessible :material_id, :quantity, :unit_price, :lot, :additional_information,
                  :creditor_id, :creditor_proposals_attributes

  attr_accessor :order

  attr_modal :material, :quantity, :unit_price

  belongs_to :material
  belongs_to :licitation_process_lot
  belongs_to :licitation_process
  belongs_to :creditor

  has_many :bidder_proposals
  has_many :licitation_process_classifications, :as => :classifiable, :dependent => :destroy
  has_many :creditor_proposals, dependent: :destroy, class_name: 'PurchaseProcessCreditorProposal',
    source: :purchase_process_creditor_proposals

  has_one  :trading_item, :dependent => :restrict

  accepts_nested_attributes_for :creditor_proposals

  delegate :reference_unit, :description, :to => :material, :allow_nil => true
  delegate :direct_purchase?, :to => :licitation_process, :allow_nil => true

  validates :material, :quantity, :lot, :presence => true
  validates :creditor, presence: true, if: :direct_purchase?

  orderize "id DESC"
  filterize

  scope :licitation_process_id, lambda { |licitation_process_id|
    where(:licitation_process_id => licitation_process_id)
  }

  scope :without_lot_or_ids, lambda { |ids|
    where { licitation_process_lot_id.eq(nil) | id.in(ids) }
  }

  def self.without_lot
    where { licitation_process_lot_id.eq(nil) }
  end

  def self.without_lot?
    without_lot.any?
  end

  def to_s
    material.to_s
  end

  def estimated_total_price
    (quantity || BigDecimal(0)) * (unit_price || BigDecimal(0))
  end

  def bidder_proposal?(bidder)
    bidder_proposals.where { bidder_id.eq(bidder.id) }.any?
  end

  def unit_price_by_bidder(bidder)
    first = bidder.proposals.select { |item| item.administrative_process_budget_allocation_item == self }.first

    first.nil? ? BigDecimal(0) : first.unit_price
  end

  def total_value_by_bidder(bidder)
    (unit_price_by_bidder(bidder) || BigDecimal(0)) * quantity
  end

  def winning_bid
    licitation_process_classifications.detect { |classification| classification.situation == SituationOfProposal::WON}
  end
end
