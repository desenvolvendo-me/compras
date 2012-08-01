class LicitationProcessLotsController < CrudController
  before_filter :updatable?, :only => [:new, :create, :update, :destroy]

  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def create
    create! { licitation_process_lots_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update! { licitation_process_lots_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! { licitation_process_lots_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
    end
  end

  protected

  def updatable?
    if params[:licitation_process_id]
      parent = LicitationProcess.find(params[:licitation_process_id])
    elsif params[:licitation_process_lot]
      parent = LicitationProcess.find(params[:licitation_process_lot][:licitation_process_id])
    else
      parent = LicitationProcessLot.find(params[:id]).licitation_process
    end

    return if parent.updatable?

    raise Exceptions::Unauthorized
  end
end
