class DepartmentsController < CrudController
  has_scope :synthetic, type: :boolean
  has_scope :analytical, type: :boolean
  has_scope :term

  # def create
  #   create! { edit_resource_path(resource) }
  # end

  def new
    object = build_resource
    # object.mask_number = '99.99.99.999.999'

    super
  end

end
