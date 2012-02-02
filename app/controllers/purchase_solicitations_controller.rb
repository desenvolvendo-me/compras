class PurchaseSolicitationsController < CrudController
  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING

    super
  end

  def create
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING

    super
  end
end
