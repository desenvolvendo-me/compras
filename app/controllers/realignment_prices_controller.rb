class RealignmentPricesController < CrudController
  actions :all, except: :destroy

  def index
    @purchase_process = LicitationProcess.find(params[:purchase_process_id])
    @creditors = Creditor.winners(@purchase_process)
  end

  def new
    object = build_resource
    object.purchase_process = LicitationProcess.find(params[:purchase_process_id])
    object.creditor = Creditor.find(params[:creditor_id])
    object.lot = params[:lot].to_i if params[:lot]

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource.purchase_process_id) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource.purchase_process_id) }
    end
  end
end
