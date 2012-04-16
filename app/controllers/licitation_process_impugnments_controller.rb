class LicitationProcessImpugnmentsController < CrudController
  def new
    object = build_resource
    object.situation = Situation::PENDING

    super
  end

  def create
    object = build_resource
    object.envelope_delivery_date = object.licitation_process.envelope_delivery_date
    object.envelope_delivery_time = object.licitation_process.envelope_delivery_time
    object.envelope_opening_date = object.licitation_process.envelope_opening_date
    object.envelope_opening_time = object.licitation_process.envelope_opening_time
    object.situation = Situation::PENDING

    super
  end
end
