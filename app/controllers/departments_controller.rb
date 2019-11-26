class DepartmentsController < CrudController
  has_scope :term, :allow_blank => true
  # has_scope :limit
end
