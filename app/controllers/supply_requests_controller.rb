class SupplyRequestsController < CrudController
  has_scope :by_purchase_solicitation
  has_scope :by_creditor
  has_scope :by_ids

  def new
    object = build_resource
    object.user = current_user
    object.authorization_date = Date.today
    object.year = Date.today.year

    super
  end

  def edit
    @hidden_field = supply_hidden_field?
  end

  def index
    @gestor = gestor?
    super
  end

  def api_show
    supply_request = SupplyRequest.where(id: params["supply_request_ids"])
    render :json => supply_request.to_json(include: {items: {include: :material}})
  end

  protected

  def gestor?
    UserPurchasingUnit.where(user_id:current_user.id).count == 0 ? false:true
  end

  def supply_hidden_field?
    purchasing_unit_ids = resource.try(:purchase_solicitation).try(:department).try(:purchasing_unit)
    current_user.user_purchasing_units.where(purchasing_unit_id: [purchasing_unit_ids]).any?
  end

  def filters(collection)
    purchase_solicitation = get_purchase_solicitation_by_purchase_unit

    collection.where("purchase_solicitation_id in (?) or compras_supply_requests.user_id = ? ",
                     purchase_solicitation,current_user.id )
  end

  private

  def get_purchase_solicitation_by_purchase_unit
    use_pur_uni = UserPurchasingUnit.where(user_id: current_user.id).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)", use_pur_uni).pluck(:id)
    PurchaseSolicitation.where("department_id in (?)", departments).pluck(:id)
  end

  def end_of_association_chain
    user_ids = UserPurchasingUnit.where(purchasing_unit_id:  current_user.purchasing_units.pluck(:id)).pluck(:user_id).uniq
    user_ids += [current_user.id]
    SupplyRequest.where(user_id: user_ids)
  end

end