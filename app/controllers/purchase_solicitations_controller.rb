class PurchaseSolicitationsController < CrudController
  has_scope :term, allow_blank: true
  has_scope :without_price_collection, type: :boolean
  has_scope :without_purchase_process, type: :boolean
  has_scope :by_material_id
  has_scope :except_ids, :type => :array
  has_scope :can_be_grouped, :type => :boolean
  has_scope :by_licitation_process
  has_scope :by_model_request
  has_scope :by_deparment_permited
  has_scope :by_department_user_access_and_licitation_process
  has_scope :by_kind
  has_scope :by_id
  has_scope :not_demand, type: :boolean, default: true, only: [:index]
  has_scope :by_secretaries_permited
  has_scope :by_deparment, type: :boolean, default: true, only: [:index] do |controller, scope|
    scope.by_deparment(controller.current_user.id)
  end
  has_scope :by_years, type: :boolean, default: true, only: [:index]

  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.request_date = Date.current
    object.accounting_year = Date.current.year

    super
  end

  def create
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING

    # create! do |success, failure|
    #   success.html { redirect_to edit_resource_path }
    # end
    super
  end

  def update
    raise Exceptions::Unauthorized unless resource.editable?

    # update! do |success, failure|
    #   success.html { redirect_to edit_resource_path }
    # end
    super
  end

  def department
    render :json => {description: PurchaseSolicitation.find(params['purchase_solicitation_id']).department.to_s}
  end

  def balance
    purchase_solicitation = LicitationProcess.find(params["purchase_process_id"]).purchase_solicitations.where(purchase_solicitation_id: params["purchase_solicitation_id"]).first
    pledge_requests = PledgeRequest.joins(:items).where("compras_pledge_request_items.purchase_solicitation_id = #{params["purchase_solicitation_id"]}")

    total_expected_value = purchase_solicitation.expected_value
    total_pledge = pledge_requests.sum(:amount)

    render :json => {balance: total_expected_value - total_pledge}
  end

  def api_show
    purchase_solicitation = PurchaseSolicitation.find(params["purchase_solicitation_id"])

    render :json => purchase_solicitation.to_json(include: {items: {include: {material: {include: [:reference_unit, :material_class]}}}})
  end

  protected

  def interpolation_options
    {:resource_name => "#{resource_class.model_name.human} #{resource.code}/#{resource.accounting_year}"}
  end
end