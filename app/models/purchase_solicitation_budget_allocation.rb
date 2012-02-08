class PurchaseSolicitationBudgetAllocation < ActiveRecord::Base
  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :estimated_value, :expense_complement, :blocked
  attr_protected :budget_allocation

  attr_accessor :budget_allocation_code

  validates :budget_allocation_id, :estimated_value, :presence => true

  belongs_to :purchase_solicitation
  belongs_to :budget_allocation
end
