class SupplyRequestsController < CrudController
  def new
    object = build_resource
    object.user = current_user

    super
  end

  def index
    @supply_requests = filters(collection)
  end

  def api_show
    supply_request = SupplyRequest.where(id: params["supply_request_ids"])
    render :json => supply_request.to_json(include: {items: {include: :material}})
  end

  protected

  def filters(collection)
    use_pur_uni = UserPurchasingUnit.where(user_id:current_user.id).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
    pur_sol = PurchaseSolicitation.where("department_id in (?)",departments).pluck(:id)

    collection.where("purchase_solicitation_id in (?) or user_id = ? ",
                     pur_sol,current_user.id )
  end

end