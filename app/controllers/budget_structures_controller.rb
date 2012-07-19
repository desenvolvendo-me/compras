class BudgetStructuresController < CrudController
  has_scope :synthetic, :type => :boolean
end
