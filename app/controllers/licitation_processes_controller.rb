class LicitationProcessesController < CrudController
  actions :all, :except => [ :destroy ]

  has_scope :with_price_registrations, :type => :boolean

  before_filter :block_administrative_process_not_allowed, :only => [:new, :create]
  before_filter :localize_administrative_process

  def new
    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current
    object.administrative_process = @administrative_process
    object.modality = @administrative_process.modality
    object.judgment_form = @administrative_process.judgment_form

    super
  end

  def create
    create!{ edit_administrative_process_path(resource.administrative_process) }
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
      update!{ edit_administrative_process_path(resource.administrative_process) }
    end
  end

  def show
    render :layout => 'report'
  end

  protected

  def create_resource(object)
    BidderStatusChanger.new(object).change

    object.process = object.next_process
    object.licitation_number = object.next_licitation_number

    super
  end

  def update_resource(object, attributes)
    return unless object.updatable?
    object.localized.assign_attributes(*attributes)

    BidderStatusChanger.new(object).change

    object.save
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
