class BudgetAllocationCapability < Accounting::Model
  include BelongsToResource

  belongs_to :capability

  belongs_to_resource :budget_allocation
end
