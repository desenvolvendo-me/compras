class LicitationProcessRatificationsController < CrudController
  actions :all, :except => :destroy

  def new
    object = build_resource
    object.ratification_date = Date.current
    object.adjudication_date = Date.current
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def create
    create! { licitation_process_ratifications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update! { licitation_process_ratifications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def show
    render :layout => 'report'
  end

  protected

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
    end
  end

  def create_resource(object)
    object.transaction do
      if super
        approve_licitation_process(object.licitation_process)
      end
    end
  end

  def approve_licitation_process(licitation_process)
    licitation_process.update_status(LicitationProcessStatus::APPROVED)
  end
end
