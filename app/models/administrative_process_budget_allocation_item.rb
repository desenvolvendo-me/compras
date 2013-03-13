class AdministrativeProcessBudgetAllocationItem < Compras::Model
  attr_accessible :material_id, :quantity, :unit_price

  attr_accessor :order

  attr_modal :material, :quantity, :unit_price

  belongs_to :material
  belongs_to :licitation_process_lot
  belongs_to :licitation_process

  has_many :bidder_proposals
  has_many :licitation_process_classifications, :as => :classifiable, :dependent => :destroy

  has_one  :trading_item, :dependent => :restrict

  delegate :reference_unit, :description, :to => :material, :allow_nil => true

  validates :material, :quantity, :presence => true

  orderize "id DESC"
  filterize

  scope :by_licitation_process_id, lambda { |licitation_process_id|
    where { licitation_process_id.eq licitation_process_id }
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
