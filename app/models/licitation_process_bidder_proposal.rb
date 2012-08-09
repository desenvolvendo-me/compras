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
  delegate :reference_unit, :description, :code, :to => :material, :allow_nil => true
  delegate :creditor, :to => :licitation_process_bidder, :allow_nil => true

  after_initialize :set_default_values

  def total_price
    return 0 unless quantity && unit_price
    quantity * unit_price
  end

  protected

  def set_default_values
    self.situation ||= SituationOfProposal::UNDEFINED
  end
end
