class GovernmentProgramsController < CrudController
  def new
    object = build_resource
    object.status = Status::ACTIVE
  end

  def create
    object = build_resource
    object.status = Status::ACTIVE

    super
  end
end
