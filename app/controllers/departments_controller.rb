class DepartmentsController < CrudController
  has_scope :synthetic, type: :boolean
  has_scope :analytical, type: :boolean
  has_scope :term

  def create
    create! { edit_resource_path(resource) }
  end

end
