class CapabilitiesController < CrudController
  def new
    object = build_resource
    object.source = CapabilitySource::MANUAL

    super
  end

  def create
    object = build_resource
    object.source = CapabilitySource::MANUAL

    super
  end
end
