class LicitationProcessPublicationsController < CrudController
  defaults collection_name: :publications

  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])
    object.publication_of = PublicationOf::CONFIRMATION if object.licitation_process.simplified_processes?

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

  private

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
    end
  end

  def create_resource(object)
    if object.save
      PurchaseProcessDatesFiller.fill(object.licitation_process)

      return true
    end

    false
  end
end
