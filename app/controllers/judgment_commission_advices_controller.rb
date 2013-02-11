class JudgmentCommissionAdvicesController < CrudController
  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(parent_id)
    object.year = Date.current.year

    super
  end

  def create
    create! { judgment_commission_advices_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update! { judgment_commission_advices_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! { judgment_commission_advices_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def begin_of_association_chain
    if parent_id
      @parent = LicitationProcess.find(parent_id)
    end
  end

  protected

  def parent_id
    params[:licitation_process_id]
  end
end
