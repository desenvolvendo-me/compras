class SupplyRequestsController < CrudController
  has_scope :by_purchase_solicitation
  has_scope :by_creditor

  def new
    object = build_resource
    object.user = current_user

    super
  end

  def index
    @supply_requests = filters(collection) if params[:suplly_requests].nil?
    @supply_requests = SupplyRequest.where("id in (?)",params[:suplly_requests]) unless params[:suplly_requests].nil?
    @gestor = gestor?
  end

  def api_show
    supply_request = SupplyRequest.where(id: params["supply_request_ids"])
    render :json => supply_request.to_json(include: {items: {include: :material}})
  end

  protected

  def gestor?
    UserPurchasingUnit.where(user_id:current_user).count == 0 ? false:true
  end

  def filters(collection)
    use_pur_uni = UserPurchasingUnit.where(user_id:current_user.id).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
    pur_sol = PurchaseSolicitation.where("department_id in (?)",departments).pluck(:id)

    collection.where("purchase_solicitation_id in (?) or user_id = ? ",
                     pur_sol,current_user.id )
  end

end