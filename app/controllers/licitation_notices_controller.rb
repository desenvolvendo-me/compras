class LicitationNoticesController < CrudController
  def new
    object = build_resource
    object.date = Date.current

    super
  end

  protected

  def create_resource(object)
    object.number = object.next_number

    super
  end
end
