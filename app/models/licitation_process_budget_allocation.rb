class LicitationProcessBudgetAllocation < ActiveRecord::Base
  attr_accessible :licitation_process_id, :budget_allocation_id, :estimated_value, :pledge_type

  has_enumeration_for :pledge_type, :with => PledgeType

  belongs_to :licitation_process
  belongs_to :budget_allocation

  delegate :expense_economic_classification, :amount, :to => :budget_allocation, :allow_nil => true

  validates :budget_allocation, :estimated_value, :pledge_type, :presence => true
end
