class LicitationProcessRatificationsController < CrudController
  def new
    object = build_resource
    object.ratification_date = Date.current
    object.adjudication_date = Date.current

    super
  end
end
