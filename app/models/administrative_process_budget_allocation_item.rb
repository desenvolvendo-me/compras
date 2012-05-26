class AdministrativeProcessBudgetAllocationItem < ActiveRecord::Base
  attr_accessible :administrative_process_budget_allocation_id, :material_id, :quantity, :unit_price

  attr_accessor :order

  belongs_to :administrative_process_budget_allocation
  belongs_to :material
  belongs_to :licitation_process_lot

  has_many :licitation_process_bidder_proposals

  delegate :reference_unit, :description, :to => :material, :allow_nil => true
  delegate :administrative_process_id, :to => :administrative_process_budget_allocation, :allow_nil => true

  delegate :type_of_calculation, :to => :administrative_process_budget_allocation, :allow_nil => true

  delegate :provider, :total_price, :to => :winner_proposals, :allow_nil => true, :prefix => true

  validates :material, :quantity, :unit_price, :presence => true

  orderize :id
  filterize

  scope :administrative_process_id, lambda { |administrative_process_id|
    joins { administrative_process_budget_allocation }.
    where { administrative_process_budget_allocation.administrative_process_id.eq administrative_process_id }
  }

  def self.without_lot
    where { licitation_process_lot_id.eq(nil) }
  end

  def self.without_lot?
    without_lot.any?
  end

  def estimated_total_price
    if quantity && unit_price
      quantity * unit_price
    else
      0
    end
  end

  def winner_proposals(classificator = LicitationProcessProposalsClassificatorByItem)
    classificator.new(self, type_of_calculation).winner_proposals
  end

  def bidder_proposal?(bidder)
    licitation_process_bidder_proposals.where { |p| p.licitation_process_bidder_id.eq(bidder.id) }.any?
  end
end
