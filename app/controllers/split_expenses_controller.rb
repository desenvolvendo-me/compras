class SplitExpensesController < CrudController
  has_scope :term, :allow_blank => true
end