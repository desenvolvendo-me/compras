class LegalAnalysisAppraisalsController < CrudController
  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def create
    create! { legal_analysis_appraisals_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update! { legal_analysis_appraisals_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! { legal_analysis_appraisals_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
    end
  end
end
