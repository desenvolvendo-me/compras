class PurchaseSolicitationsController < CrudController
  has_scope :term, allow_blank: true
  has_scope :without_price_collection, type: :boolean
  has_scope :without_purchase_process, type: :boolean
  has_scope :by_material_id
  has_scope :except_ids, :type => :array
  has_scope :can_be_grouped, :type => :boolean
  # has_scope :by_licitation_process

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

  protected

  def default_filters
    { :accounting_year => lambda { Date.current.year } }
  end

  def interpolation_options
    { :resource_name => "#{resource_class.model_name.human} #{resource.code}/#{resource.accounting_year}" }
  end
end
