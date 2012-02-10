class PurchaseSolicitationsController < CrudController
  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.request_date = Date.current
    object.accounting_year = Date.current.year

    super
  end

  def create
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.items.each do |item|
      item.status = PurchaseSolicitationItemStatus::PENDING
    end

    super
  end
end
