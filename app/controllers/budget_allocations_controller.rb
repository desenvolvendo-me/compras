class BudgetAllocationsController < CrudController
  has_scope :term
  has_scope :budget_structure_id
end
