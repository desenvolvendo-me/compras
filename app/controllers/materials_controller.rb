class MaterialsController < CrudController
  def create
    object = build_resource
    MaterialCodeGenerator.new(object).generate!

    super
  end

  def update
    object = resource
    MaterialCodeGenerator.new(resource).generate!

    super
  end
end
