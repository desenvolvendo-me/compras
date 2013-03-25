class BudgetAllocationsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :budget_structure_id
end
