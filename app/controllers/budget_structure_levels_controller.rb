class BudgetStructureLevelsController < CrudController
  has_scope :search_by_configuration_id
  actions :modal
end
