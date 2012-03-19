class AdministrativeProcessesController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.status = AdministrativeProcessStatus::WAITING
    object.responsible = current_user.employee

    super
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
