class PurchaseSolicitationBudgetAllocation < ActiveRecord::Base
  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :estimated_value, :blocked
  attr_accessible :economic_classification_of_expenditure_id

  attr_protected :budget_allocation, :economic_classification_of_expenditure

  attr_accessor :budget_allocation_code

  validates :budget_allocation_id, :estimated_value, :presence => true

  belongs_to :purchase_solicitation
  belongs_to :budget_allocation
  belongs_to :economic_classification_of_expenditure
end
