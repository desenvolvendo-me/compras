class BudgetAllocationCapability < Accounting::Model
  belongs_to :budget_allocation
  belongs_to :capability

  delegate :amount_can_be_updated?, :to => :budget_allocation, :allow_nil => true
end
