class LicitationProcessImpugnmentsController < CrudController
  def new
    object = build_resource
    object.situation = Situation::PENDING

    super
  end
end