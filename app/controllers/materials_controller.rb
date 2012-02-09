class MaterialsController < CrudController
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
