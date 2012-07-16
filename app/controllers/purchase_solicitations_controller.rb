class PurchaseSolicitationsController < CrudController
  has_scope :by_material_id

  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.request_date = Date.current
    object.accounting_year = Date.current.year
    object.responsible = current_user.authenticable

    super
  end

  def create
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING

    super
  end
end
