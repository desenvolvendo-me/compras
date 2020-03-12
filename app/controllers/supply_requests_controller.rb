class SupplyRequestsController < CrudController
  def new
    object = build_resource
    object.user = current_user

    super
  end

  def index
    @supply_requests = filter_by_department(collection)
  end

  def api_show
    supply_request = SupplyRequest.where(id: params["supply_request_ids"])
    render :json => supply_request.to_json(include: {items: {include: :material}})
  end

  protected

  def filter_by_department(collection)
    departments = DepartmentPerson.where(user_id: current_user.id).pluck(:department_id)
    collection.joins(:purchase_solicitation).where("compras_purchase_solicitations.department_id IN (?) ", departments)
  end
end
