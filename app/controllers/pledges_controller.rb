class PledgesController < CrudController
  def new
    object = build_resource
    object.emission_date = Date.current

    super
  end
end
