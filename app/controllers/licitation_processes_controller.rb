class LicitationProcessesController < CrudController
  actions :all, :except => [:destroy]

  has_scope :by_modality_type
  has_scope :trading, :type => :boolean
  has_scope :published_edital, :type => :boolean
  has_scope :by_ratification_and_year
  has_scope :ratified, type: :boolean

  def new
    object = build_resource
    object.process_date = Date.current
    object.status = PurchaseProcessStatus::WAITING_FOR_OPEN
    object.purchase_solicitation_import_option = PurchaseSolicitationImportOption::AVERAGE_PRICE

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource) }
    end
  end

  def show
    render :layout => 'report'
  end

  def material_total_balance
    quantity = params["quantity"]
    licitation_process = LicitationProcess.find(params[:licitation_process_id])
    material = Material.find(params[:material_id])
    supply_order = SupplyOrder.find(params[:supply_order_id]) if params[:supply_order_id].to_i > 0

    response = SupplyOrder.total_balance(licitation_process, material, quantity, supply_order)

    render :json => {total: response["total"], balance: response["balance"]}
  end


  def default_filters
    {:year => lambda { Date.current.year }}
  end

  protected
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
end
