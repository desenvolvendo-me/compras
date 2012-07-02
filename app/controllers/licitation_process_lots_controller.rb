class LicitationProcessLotsController < CrudController
  before_filter :updatable?, :only => [:new, :create, :update, :destroy]

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
    create!{ licitation_process_lots_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update!{ licitation_process_lots_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! do |success, failure|
      failure.html do
        redirect_to edit_resource_path
      end

      success.html do
        redirect_to licitation_process_lots_path(:licitation_process_id => resource.licitation_process_id)
      end
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
