class LicitationProcessClassification < Compras::Model
  attr_accessible :classification, :situation, :total_value, :unit_value, :licitation_process_bidder, :classifiable

  has_enumeration_for :situation, :with => SituationOfProposal, :create_helpers => true

  belongs_to :licitation_process_bidder
  belongs_to :classifiable, :polymorphic => true

  delegate :description, :reference_unit, :quantity, :to => :classifiable, :allow_nil => true
  delegate :administrative_process_budget_allocation_items, :items, :to => :classifiable, :allow_nil => true
  delegate :benefited, :proposals, :to => :licitation_process_bidder, :allow_nil => true

  orderize :id
  filterize

  def disqualified?
    classification == -1
  end

  def benefited_value(current_percentage)
    return total_value unless benefited

    total_value - (total_value * current_percentage / 100)
  end
end
