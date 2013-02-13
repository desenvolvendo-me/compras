class LicitationProcessesController < CrudController
  actions :all, :except => [ :destroy ]

  has_scope :with_price_registrations, :type => :boolean
  has_scope :by_modality_type
  has_scope :without_trading
  has_scope :trading, :type => :boolean
  has_scope :published_edital, :type => :boolean

  before_filter :block_administrative_process_not_allowed, :only => [:new, :create]
  before_filter :localize_administrative_process

  def new
    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current
    object.administrative_process = @administrative_process
    object.judgment_form = @administrative_process.judgment_form
    object.status = LicitationProcessStatus::WAITING_FOR_OPEN
    object.delivery_location = @administrative_process.delivery_location

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource, :administrative_process_id => resource.administrative_process_id) }
    end
  end

  def update
    if params[:commit] == 'Apurar'
      resource.transaction do
        LicitationProcessClassificationGenerator.new(resource).generate!

        LicitationProcessClassificationBiddersVerifier.new(resource).verify!

        LicitationProcessClassificationSituationGenerator.new(resource).generate!
      end

      redirect_to licitation_process_path(resource)
    else
      update! do |success, failure|
        success.html { redirect_to edit_licitation_process_path(resource, :administrative_process_id => resource.administrative_process_id) }
      end
    end
  end

  def show
    render :layout => 'report'
  end

  protected

  def interpolation_options
    { :resource_name => "#{resource_class.model_name.human} #{resource.process}/#{resource.year}" }
  end

  def create_resource(object)
    object.transaction do
      BidderStatusChanger.new(object).change

      object.licitation_number = object.next_licitation_number
      object.status = LicitationProcessStatus::WAITING_FOR_OPEN

      if super
        DeliveryLocationChanger.change(object.purchase_solicitation, object.delivery_location)
      end
    end
  end

  def update_resource(object, attributes)
    return unless object.updatable?

    object.transaction do
      object.localized.assign_attributes(*attributes)

      BidderStatusChanger.new(object).change

      if object.save
        DeliveryLocationChanger.change(object.purchase_solicitation, object.delivery_location)
      end
    end
  end

  def block_administrative_process_not_allowed
    administrative_process_id = params[:administrative_process_id] || params[:licitation_process][:administrative_process_id]
    @administrative_process = AdministrativeProcess.find(administrative_process_id)

    raise Exceptions::Unauthorized unless @administrative_process.allow_licitation_process?
  end

  def localize_administrative_process
    if params[:administrative_process_id]
      @parent = AdministrativeProcess.find(params[:administrative_process_id])
    end
  end
end
