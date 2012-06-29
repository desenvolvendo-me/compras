class BudgetStructureLevelsController < CrudController
  has_scope :configuration_id
  actions :modal
end
