class PurchaseSolicitationsController < CrudController
  has_scope :term, allow_blank: true
  has_scope :without_price_collection, type: :boolean
  has_scope :without_purchase_process, type: :boolean
  has_scope :by_material_id
  has_scope :except_ids, :type => :array
  has_scope :can_be_grouped, :type => :boolean
  has_scope :by_licitation_process
  has_scope :by_model_request

  def index
    @purchase_solicitations = filter_by_department(collection)
  end

  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.request_date = Date.current
    object.accounting_year = Date.current.year
    # object.responsible = current_user.authenticable

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

  protected

  def filter_by_department(collection)
    departments = DepartmentPerson.where(user_id: current_user.id).pluck(:department_id)
    collection.where("compras_purchase_solicitations.department_id IN (?) ", departments)
  end

  def default_filters
    {:accounting_year => lambda {Date.current.year}}
  end

  def interpolation_options
    {:resource_name => "#{resource_class.model_name.human} #{resource.code}/#{resource.accounting_year}"}
  end
end