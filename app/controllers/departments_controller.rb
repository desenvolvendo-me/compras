class DepartmentsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_purchasing_unit_for_licitation_process, :allow_blank => true

end
