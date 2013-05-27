class RealigmentPricesController < CrudController
  defaults resource_class: PurchaseProcessCreditorProposal

  def index
    @creditors = licitation_process.creditors.includes(:purchase_process_creditor_proposals)
    @licitation_process = licitation_process
  end

  def edit
    CreateRealigmentPrice.create!(resource)
  end

  def update
    update! do |success, failure|
      success.html { redirect_to realigment_prices_path(purchase_process_id: licitation_process_id) }
    end
  end

  private

  def licitation_process
    LicitationProcess.find(licitation_process_id)
  end

  def licitation_process_id
    return unless params[:purchase_process_id] || params[:purchase_process_creditor_proposal]

    params[:purchase_process_id] || params[:purchase_process_creditor_proposal][:licitation_process_id]
  end
end