class MaterialsController < CrudController
  def create
    object = build_resource
    object.code = MaterialCodeGenerator.new(object).generate!

    super
  end
end
