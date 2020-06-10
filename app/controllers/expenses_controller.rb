class ExpensesController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_contract
end
