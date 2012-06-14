class BudgetStructuresController < CrudController
  has_scope :search_by_level
  has_scope :only_synthetic, :type => :boolean
end
