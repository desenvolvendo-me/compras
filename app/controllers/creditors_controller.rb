class CreditorsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_id, allow_blank: true
end
