class LicitationProcessPublicationsController < CrudController

  def index
    @parent = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def create
    create!{ licitation_process_publications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update!{ licitation_process_publications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! do |success, failure|
      failure.html do
        redirect_to edit_resource_path
      end

      success.html do
        redirect_to licitation_process_publications_path(:licitation_process_id => resource.licitation_process_id)
      end
    end
  end
end
