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
    # purchasing_units = UserPurchasingUnit.joins(:user).
    #   joins(:purchasing_unit).where("compras_user_purchasing_units.user_id=#{current_user.id}").
    #     pluck('compras_user_purchasing_units.purchasing_unit_id')
    # if purchasing_units.empty?
    #   departments = DepartmentPerson.where(user_id: current_user.id).pluck(:department_id)
    #   collection.joins(:purchase_solicitation).where("compras_purchase_solicitations.department_id IN (?) ", departments)
    # else
    #   departments = Department.where('purchasing_unit_id in (?)',purchasing_units).pluck(:id)
    #   collection.joins(:purchase_solicitation).where("compras_purchase_solicitations.department_id IN (?) ", departments)
    # end

    # purchasing_units = UserPurchasingUnit.joins(:user).
    #   joins(:purchasing_unit).where("compras_user_purchasing_units.user_id=#{current_user.id}").
    #     pluck('compras_user_purchasing_units.purchasing_unit_id')
    # departments = Department.where('purchasing_unit_id in (?)',purchasing_units).pluck(:id)
    # users = DepartmentPerson.where("department_id in (?)", users).pluck(:user_id)
    # collection.where(" user_id in (?) ",[current_user.id])

    # collection.where("user_id in (?) ",[current_user.id])

    # com o user_id pega purchasing_unit_id
    # UserPurchasingUnit.where(user_id:22)
    # com a lista de purchasing_units pega os users od departamento
    # Department.joins(:department_people).where(purchasing_unit_id:2)
    # filtra a lista de supply_request com a lista de users + user atual

    use_pur_uni = UserPurchasingUnit.where(user_id:current_user.id).pluck(:id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
    users = DepartmentPerson.where("department_id in (?)",departments).pluck(:user_id)

    collection.where("user_id in (?) ",users+[current_user.id])

  end

end
