class PrecatoryTypesController < CrudController
  has_scope :active, :type => :boolean

  def new
    object = build_resource
    object.status = Status::ACTIVE

    super
  end

  def create
    object = build_resource
    object.status = Status::ACTIVE

    super
  end
end
