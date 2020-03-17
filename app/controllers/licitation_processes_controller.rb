class LicitationProcessesController < CrudController
  actions :all, :except => [:destroy]
  before_filter :with_access, only: [:index, :modal]

  has_scope :by_modality_type
  has_scope :trading, :type => :boolean
  has_scope :published_edital, :type => :boolean
  has_scope :by_ratification_and_year
  has_scope :ratified, type: :boolean
  has_scope :by_contract
  has_scope :by_creditor
  has_scope :term, :allow_blank => true
  has_scope :by_status, :allow_blank => true

  def new
    object = build_resource
    object.process_date = Date.current
    object.status = PurchaseProcessStatus::WAITING_FOR_OPEN
    object.purchase_solicitation_import_option = PurchaseSolicitationImportOption::AVERAGE_PRICE

    super
  end

  def create
    create! do |success, failure|
      success.html {redirect_to edit_licitation_process_path(resource)}
    end
  end

  def update
    update! do |success, failure|
      success.html {redirect_to edit_licitation_process_path(resource)}
    end
  end

  def show
    render :layout => 'report'
  end

  def material_total_balance
    quantity = params["quantity"]
    licitation_process = LicitationProcess.find(params[:licitation_process_id])
    material = Material.find(params[:material_id])
    purchase_solicitation = PurchaseSolicitation.find(params[:purchase_solicitation_id])
    contract = Contract.find(params[:contract_id])

    response = supply_order(licitation_process, material, purchase_solicitation, quantity, contract) if params[:supply_order_id].present?
    response = supply_request(licitation_process, material, purchase_solicitation, quantity, contract) if params[:supply_request_id].present?

    render :json => {total: response["total"], balance: response["balance"]}
  end


  def default_filters
    {:year => lambda {Date.current.year}}
  end

  protected

  def filter_by_purchasing_unit(collection)
    return collection if params[:filter][:purchasing_unit].nil?

    purchasing_units = UserPurchasingUnit.where(user_id: current_user.id).pluck(:purchasing_unit_id)
    collection.where("purchasing_unit_id IN (?) ", purchasing_units)
  end

  def interpolation_options
    {:resource_name => "#{resource_class.model_name.human} #{resource.process}/#{resource.year}"}
  end

  def create_resource(object)
    object.transaction do
      object.year = object.process_date_year
      object.status = PurchaseProcessStatus::WAITING_FOR_OPEN

      if super
        PurchaseProcessFractionationCreator.create!(object)

        fractionation_warning(object)

        true
      end
    end
  end

  def update_resource(object, attributes)
    if super
      object.transaction do
        PurchaseProcessFractionationCreator.create!(object)

        fractionation_warning(object)

        return true
      end
    end

    false
  end

  def fractionation_warning(object)
    warning = PurchaseProcessFractionationWarning.message(object)

    if warning
      flash[:alert] = warning
    end
  end

  private

  def with_access
    @licitation_processes = filter_by_purchasing_unit(collection)
  end

  def supply_order(licitation_process, material, purchase_solicitation, quantity, contract)
    supply_order = SupplyOrder.find(params[:supply_order_id]) if params[:supply_order_id].to_i > 0

    response = SupplyOrder.total_balance(licitation_process, purchase_solicitation, material, quantity, supply_order, contract)
  end

  def supply_request(licitation_process, material, purchase_solicitation, quantity, contract)
    supply_request = SupplyRequest.find(params[:supply_request_id]) if params[:supply_request_id].to_i > 0

    response = SupplyRequest.total_balance(licitation_process, purchase_solicitation, material, quantity, supply_request, contract)
  end
end
