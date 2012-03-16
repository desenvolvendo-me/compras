class MaterialsController < CrudController
  has_scope :licitation_object_id

  def create
    object = build_resource
    MaterialCodeGenerator.new(object).generate!

    super
  end

  protected

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    MaterialCodeGenerator.new(object).generate!

    super
  end
end
