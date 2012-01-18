class PeopleController < CrudController
  respond_to :js

  def new
    object = build_resource
    object.personable = Individual.new

    super
  end

  protected

  def create_resource(object)
    return unless super

    taxpayer = ISSIntel::Taxpayer.new(object.iss_intel_attributes)
    taxpayer.update!
  end

  def update_resource(object, attributes)
    return unless super

    taxpayer = ISSIntel::Taxpayer.new(object.iss_intel_attributes)
    taxpayer.update!
  end
end
