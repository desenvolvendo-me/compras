class SupplyRequestsController < CrudController
  has_scope :by_purchase_solicitation
  has_scope :by_creditor

  def new
    object = build_resource
    object.user = current_user

    super
  end

  def material_unit_value
    lic_pro_id = params['licitation_process_id']
    contract_id = params['contract_id']
    material_id = params['material_id']

    material = get_material_unit_value(lic_pro_id,contract_id,material_id)
    render :json => {retorno: material}
  end

  def edit
    @gestor = gestor?
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
    UserPurchasingUnit.where(user_id:current_user.id).count == 0 ? false:true
  end

  def filters(collection)
    use_pur_uni = UserPurchasingUnit.where(user_id:current_user.id).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
    pur_sol = PurchaseSolicitation.where("department_id in (?)",departments).pluck(:id)

    collection.where("purchase_solicitation_id in (?) or user_id = ? ",
                     pur_sol,current_user.id )
  end

  def get_material_unit_value(lic_pro_id,contract_id,material_id)
    lpr = LicitationProcessRatification.joins("inner join compras_supply_requests on compras_supply_requests.creditor_id = compras_licitation_process_ratifications.creditor_id").where(licitation_process_id:lic_pro_id,compras_supply_requests:{contract_id:contract_id}).pluck(:id).uniq
    sql =	"select material_id,unit_price from public.compras_licitation_process_ratification_items ri inner join public.compras_realignment_price_items pi on ri.realignment_price_item_id = pi.id inner join public.compras_purchase_process_items cpi on cpi.id = ri.purchase_process_item_id where ri.licitation_process_ratification_id in (#{lpr.join(',')}) and cpi.material_id = #{material_id} ;"
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array
  end
end