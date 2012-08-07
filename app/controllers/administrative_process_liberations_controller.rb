class AdministrativeProcessLiberationsController < CrudController
  actions :all, :except => [ :destroy, :index, :update]

  before_filter :check_administrative_process, :only => [ :new, :create ]

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.administrative_process = @administrative_process
    object.date = Date.current

    super
  end

  def create
    create! { edit_administrative_process_path(@administrative_process) }
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      AdministrativeProcessStatusUpdater.new(object.administrative_process).release!
    end
  end

  def check_administrative_process
    administrative_process_id = params[:administrative_process_id] || params[:administrative_process_liberation][:administrative_process_id]

    @administrative_process = AdministrativeProcess.find(administrative_process_id)

    raise Exceptions::Unauthorized unless @administrative_process.waiting?
  end
end
