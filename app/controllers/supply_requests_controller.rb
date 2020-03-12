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
    purchasing_units = UserPurchasingUnit.joins(:user).
      joins(:purchasing_unit).where("compras_user_purchasing_units.user_id=#{current_user.id}").
        pluck('compras_user_purchasing_units.purchasing_unit_id')
    if purchasing_units.empty?
      departments = DepartmentPerson.where(user_id: current_user.id).pluck(:department_id)
      collection.joins(:purchase_solicitation).where("compras_purchase_solicitations.department_id IN (?) ", departments)
    else
      departments = Department.where('purchasing_unit_id in (?)',purchasing_units).pluck(:id)
      collection.joins(:purchase_solicitation).where("compras_purchase_solicitations.department_id IN (?) ", departments)
    end
  end

end
