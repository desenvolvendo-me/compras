class LicitationProcessClassification < Compras::Model
  attr_accessible :classification, :situation, :total_value, :unit_value, :licitation_process_bidder, :classifiable

  has_enumeration_for :situation, :with => LicitationProcessClassificationSituation

  belongs_to :licitation_process_bidder
  belongs_to :classifiable, :polymorphic => true

  delegate :description, :reference_unit, :quantity, :to => :classifiable, :allow_nil => true
  delegate :administrative_process_budget_allocation_items, :items, :to => :classifiable, :allow_nil => true
  delegate :benefited, :to => :licitation_process_bidder, :allow_nil => true

  orderize :id
  filterize

  def disqualified?
    classification == -1
  end

  def won!
    update_column(:situation, LicitationProcessClassificationSituation::WON)
  end

  def lost!
    update_column(:situation, LicitationProcessClassificationSituation::LOST)
  end

  def equalized!
    update_column(:situation, LicitationProcessClassificationSituation::EQUALIZED)
  end

  def benefited_value(current_percentage)
    return total_value unless benefited

    total_value - (total_value * current_percentage / 100)
  end
end
