class SupplyRequestsController < CrudController
  has_scope :by_purchase_solicitation
  has_scope :by_creditor
  has_scope :by_ids
  has_scope :filter_by_user, type: :boolean, default: true, only: [:index, :edit] do |controller, scope|
    scope.filter_by_user(controller.current_user)
  end

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

  def update_resource(object, attributes)
    object.transaction do
      updatabled = object.updatabled
      if super
        if object.updatabled != updatabled
          SupplyRequestAttendanceCreator.create!(object, current_user)
        end
      end
    end
  end

  def get_purchase_solicitation_by_purchase_unit
    use_pur_uni = UserPurchasingUnit.where(user_id: current_user.id).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)", use_pur_uni).pluck(:id)
    PurchaseSolicitation.where("department_id in (?)", departments).pluck(:id)
  end

end