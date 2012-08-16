class CapabilitySourcesController < CrudController
  def new
    object = build_resource
    object.source = Source::MANUAL

    super
  end

  def create
    object = build_resource
    object.source = Source::MANUAL

    super
  end
end
