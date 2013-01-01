class LicitationProcessClassification < Compras::Model
  attr_accessible :classification, :situation, :total_value, :unit_value, :bidder, :classifiable

  has_enumeration_for :situation, :with => SituationOfProposal, :create_helpers => true

  belongs_to :bidder
  belongs_to :classifiable, :polymorphic => true

  delegate :description, :reference_unit, :quantity,
           :to => :classifiable, :allow_nil => true
  delegate :administrative_process_budget_allocation_items, :items,
           :to => :classifiable, :allow_nil => true
  delegate :benefited, :proposals, :will_submit_new_proposal_when_draw,
           :to => :bidder, :allow_nil => true

  orderize :id
  filterize

  scope :disqualified, where { classification.eq(-1) }

  def self.for_active_bidders
    joins { bidder }.
    where { bidder.status.not_eq(Status::INACTIVE) | bidder.status.eq(nil) }
  end

  def self.for_item(item_id)
    joins { classifiable(AdministrativeProcessBudgetAllocationItem) }.
    where { classifiable.id.eq(item_id)}
  end

  def disqualified?
    classification == -1
  end

  def lose!
    update_column(:situation, SituationOfProposal::LOST)
  end

  def win!
    update_column(:situation, SituationOfProposal::WON)
  end

  def equalize!
    update_column(:situation, SituationOfProposal::EQUALIZED)
  end
end
