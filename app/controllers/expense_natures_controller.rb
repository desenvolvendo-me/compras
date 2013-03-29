class ExpenseNaturesController < CrudController
  actions :modal, :index

  has_scope :term
end
