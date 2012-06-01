class PeopleController < CrudController
  has_scope :except_special_entry

  respond_to :js

  def new
    object = build_resource
    object.personable = Individual.new

    super
  end

  protected

  def create_resource(object)
    return unless super

    if !object.special?
      taxpayer = ISSIntel::Taxpayer.new(object.iss_intel_attributes)
      taxpayer.update!
    end
  end

  def update_resource(object, attributes)
    return unless super

    if !object.special?
      taxpayer = ISSIntel::Taxpayer.new(object.iss_intel_attributes)
      taxpayer.update!
    end
  end
end
