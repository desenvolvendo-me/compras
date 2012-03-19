class LicitationProcessesController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current

    super
  end
end
