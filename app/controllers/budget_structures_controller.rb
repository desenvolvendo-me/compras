class BudgetStructuresController < CrudController
  has_scope :only_synthetic, :type => :boolean
end
