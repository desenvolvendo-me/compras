class MaterialsController < CrudController
  def create
    object = build_resource
    if object.valid?
      object.code = MaterialCodeGenerator.new(object).generate!
    end

    super
  end
end
