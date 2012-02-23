class PledgesController < CrudController
  def new
    object = build_resource
    object.emission_date = Date.current

    super
  end

  def edit
    object = resource
    object.licitation = object.joined_licitation
    object.process = object.joined_process

    super
  end
end
