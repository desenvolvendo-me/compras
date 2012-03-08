class DirectPurchasesController < CrudController
  def new
    object = build_resource
    object.employee = current_user.employee
    object.status = DirectPurchaseStatus::UNAUTHORIZED

    super
  end

  def create
    object = build_resource
    object.status = DirectPurchaseStatus::UNAUTHORIZED

    super
  end
end
