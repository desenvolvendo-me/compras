class PurchaseSolicitationBudgetAllocation < ActiveRecord::Base
  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :estimated_value, :blocked
  attr_accessible :expense_economic_classification_id

  validates :budget_allocation_id, :estimated_value, :presence => true

  belongs_to :purchase_solicitation
  belongs_to :budget_allocation
  belongs_to :expense_economic_classification
end
