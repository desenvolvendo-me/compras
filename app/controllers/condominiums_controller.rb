class CondominiumsController < CrudController
  def new
    object = build_resource
    object.build_address
    super
  end
end
