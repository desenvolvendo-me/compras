class AdministrativeProcessesController < CrudController
  actions :all, :except => [ :destroy ]

  has_scope :without_licitation_process, :type => :boolean

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
      super
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
