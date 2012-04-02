class PurchaseSolicitationsController < CrudController
  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.request_date = Date.current
    object.accounting_year = Date.current.year
    object.responsible = current_user.employee

    super
  end

  def create
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING

    super
  end
end
