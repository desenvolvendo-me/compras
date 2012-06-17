class AdministrativeProcessesController < CrudController
  actions :all, :except => :destroy

  has_scope :released, :type => :boolean

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.status = AdministrativeProcessStatus::WAITING
    object.responsible = current_user.authenticable

    super
  end

  def update
    if resource.waiting?
      if params.has_key?(:commit) && params[:commit] == 'Anular'
        resource.status = AdministrativeProcessStatus::ANNULLED
        resource.save!
        redirect_to administrative_processes_path, :notice => t('compras.messages.administrative_process_annulled_successful')
      else
        super
      end
    else
      redirect_to edit_administrative_process_path(resource)
    end
  end

  def create
    object = build_resource
    object.status = AdministrativeProcessStatus::WAITING

    super
  end

  def show
    if resource.released?
      render :layout => 'report'
    else
      redirect_to edit_administrative_process_path(resource)
    end
  end
end
