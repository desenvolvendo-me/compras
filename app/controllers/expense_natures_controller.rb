class ExpenseNaturesController < CrudController
  actions :modal, :index

  has_scope :term, allow_blank: true
  has_scope :breakdown_of, allow_blank: true
  has_scope :by_parent_id, allow_blank: true
  has_scope :by_year, allow_blank: true
end
