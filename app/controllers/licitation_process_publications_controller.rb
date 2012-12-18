class LicitationProcessPublicationsController < CrudController
  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def create
    create! { licitation_process_publications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update! { licitation_process_publications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! { licitation_process_publications_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
    end
  end

  protected

  def main_controller_name
    'administrative_processes'
  end
end
