class LicitationProcessesController < CrudController
  actions :all, :except => [ :destroy ]

  has_scope :with_price_registrations, :type => :boolean
  has_scope :by_modality_type
  has_scope :without_trading
  has_scope :trading, :type => :boolean
  has_scope :published_edital, :type => :boolean

  def new
    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current
    object.status = LicitationProcessStatus::WAITING_FOR_OPEN

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource) }
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
        success.html { redirect_to edit_licitation_process_path(resource) }
      end
    end
  end

  def show
    render :layout => 'report'
  end

  protected

  def default_filters
    { :year => lambda { Date.current.year } }
  end

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

      if object.save!
        DeliveryLocationChanger.change(object.purchase_solicitation, object.delivery_location)
      end
    end
  end
end
