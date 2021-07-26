class PurchaseProcessProposalsController < CrudController
  defaults resource_class: LicitationProcess

  before_filter :load_licitation_process, only: [:index, :new]
  before_filter :load_creditor, except: [:index]

  def index
    @creditors = resource.creditors_enabled.includes(:purchase_process_creditor_proposals)
  end

  def new
    @proposals = PurchaseProcessCreditorProposalBuilder.build_proposals(resource, @creditor)
  end

  def show
    render :layout => 'report'
  end

  def edit
    @proposals = resource.proposals_of_creditor(@creditor)
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource.id) }
    end
  end

  private

  def load_licitation_process
    set_resource_ivar LicitationProcess.find(params[:licitation_process_id])
  end

  def load_creditor
    @creditor = Creditor.find params.delete(:creditor_id)
  end

  def interpolation_options
    { resource_name: PurchaseProcessCreditorProposal.model_name.human }
  end
end
