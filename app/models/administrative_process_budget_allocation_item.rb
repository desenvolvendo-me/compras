class AdministrativeProcessBudgetAllocationItem < Compras::Model
  attr_accessible :administrative_process_budget_allocation_id, :material_id, :quantity, :unit_price

  attr_accessor :order

  attr_modal :material, :quantity, :unit_price

  belongs_to :administrative_process_budget_allocation
  belongs_to :material
  belongs_to :licitation_process_lot

  has_many :bidder_proposals
  has_many :licitation_process_classifications, :as => :classifiable, :dependent => :destroy

  has_one  :trading_item, :dependent => :restrict

  delegate :reference_unit, :description, :to => :material, :allow_nil => true
  delegate :administrative_process_id, :budget_allocation, :to => :administrative_process_budget_allocation, :allow_nil => true

  delegate :type_of_calculation, :to => :administrative_process_budget_allocation, :allow_nil => true

  validates :material, :quantity, :unit_price, :presence => true

  orderize :id
  filterize

  scope :administrative_process_id, lambda { |administrative_process_id|
    joins { administrative_process_budget_allocation }.
    where { administrative_process_budget_allocation.administrative_process_id.eq administrative_process_id }
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
    (quantity || 0) * (unit_price || 0)
  end

  def bidder_proposal?(bidder)
    bidder_proposals.where { bidder_id.eq(bidder.id) }.any?
  end

  def unit_price_by_bidder(bidder)
    first = bidder.proposals.select { |item| item.administrative_process_budget_allocation_item == self }.first

    first.nil? ? 0 : first.unit_price
  end

  def total_value_by_bidder(bidder)
    (unit_price_by_bidder(bidder) || 0) * quantity
  end

  def winning_bid
    licitation_process_classifications.detect { |classification| classification.situation == SituationOfProposal::WON}
  end
end
