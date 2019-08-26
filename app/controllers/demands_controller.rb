class DemandsController < CrudController

  def new
    object = build_resource
    object.status = DemandStatus::CREATED

    super
  end

end
