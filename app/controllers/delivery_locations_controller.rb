class DeliveryLocationsController < CrudController
  def new
    object = build_resource
    object.build_address
  end
end
