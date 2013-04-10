class PurchaseProcessAccreditationsController < CrudController
  defaults :collection_name => :purchase_process_accreditation

  actions :new, :create, :edit, :update, :show

  before_filter :parent

  def new
    object = build_resource
    object.licitation_process = parent

    super
  end

  def create
    create! { edit_licitation_process_path(parent) }
  end

  def update
    update! { edit_licitation_process_path(parent) }
  end

  def show
    render :layout => 'report'
  end

  protected

  def parent
    @parent ||= parent_from_params_or_licitation_process
  end

  def parent_id
    return unless params[:licitation_process_id] || params[:purchase_process_accreditation]

    params[:licitation_process_id] || params[:purchase_process_accreditation][:licitation_process_id]
  end

  def parent_from_params_or_licitation_process
    if parent_id
      LicitationProcess.find(parent_id)
    else
      resource.licitation_process
    end
  end
end
