class DepartmentsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_purchasing_unit_for_licitation_process, :allow_blank => true
  has_scope :by_purchasing_unit_for_licitation_process, :allow_blank => true
  has_scope :by_user, :allow_blank => true
  has_scope :by_secretary, :allow_blank => true

  def create
    create! do |success, failure|
      success.html { redirect_to edit_department_path(resource) }
    end
  end

end