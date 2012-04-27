class AdministrativeProcessesController < CrudController
  actions :all, :except => [ :destroy ]

  has_scope :without_licitation_process, :type => :boolean
  has_scope :with_released_status, :type => :boolean

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.status = AdministrativeProcessStatus::WAITING
    object.responsible = current_user.employee

    super
  end

  def update
    if resource.waiting?
      if params.has_key?(:commit) && params[:commit] == 'Liberar'
        resource.status = AdministrativeProcessStatus::RELEASED
        resource.save!
        redirect_to administrative_processes_path, :notice => t(:administrative_process_released_successful)
      elsif params.has_key?(:commit) && params[:commit] == 'Anular'
        resource.status = AdministrativeProcessStatus::CANCELED
        resource.save!
        redirect_to administrative_processes_path, :notice => t(:administrative_process_canceled_successful)
      else
        super
      end
    else
      redirect_to edit_administrative_process_path(resource.id)
    end
  end

  def create
    object = build_resource
    object.status = AdministrativeProcessStatus::WAITING

    super
  end

  def show
    render :layout => 'report'
  end
end
