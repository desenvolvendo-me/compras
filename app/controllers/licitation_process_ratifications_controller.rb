class LicitationProcessRatificationsController < CrudController
  actions :all, :except => :destroy

  def new
    object = build_resource
    object.ratification_date = Date.current
    object.adjudication_date = Date.current

    super
  end

  def show
    render :layout => 'report'
  end

  protected

  def create_resource(object)
    object.transaction do
      if super
        approve_licitation_process(object.licitation_process)
        approve_administrative_process(object.administrative_process)
      end
    end
  end

  def approve_licitation_process(licitation_process)
    licitation_process.update_status(LicitationProcessStatus::APPROVED)
  end

  def approve_administrative_process(administrative_process)
    administrative_process.update_status(AdministrativeProcessStatus::APPROVED)
  end
end
