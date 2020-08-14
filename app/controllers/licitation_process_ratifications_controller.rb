class LicitationProcessRatificationsController < CrudController
  def new
    object = build_resource
    object.ratification_date = Date.current
    object.adjudication_date = Date.current
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def create
    create! { edit_licitation_process_path(resource.licitation_process_id) }
  end

  def update
    update! { edit_licitation_process_path(resource.licitation_process_id) }
  end

  def show
    render :layout => 'report'
  end

  def destroy
    destroy! { edit_licitation_process_path(resource.licitation_process_id) }
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
        PurchaseProcessFractionationCreator.create!(object.licitation_process)

        approve_licitation_process(object.licitation_process)

        true
      end
    end
  end

  def update_resource(object, attributes)
    object.transaction do
      if super
        PurchaseProcessFractionationCreator.create!(object.licitation_process)

        true
      end
    end
  end

  def destroy_resource(object)
    object.transaction do
      super

      PurchaseProcessFractionationCreator.create!(object.licitation_process)
    end
  end

  def approve_licitation_process(licitation_process)
    licitation_process.update_status(PurchaseProcessStatus::APPROVED)
  end
end
