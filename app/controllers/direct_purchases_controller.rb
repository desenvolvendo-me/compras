class DirectPurchasesController < CrudController
  def new
    object = build_resource
    object.employee = current_user.employee

    super
  end
end
