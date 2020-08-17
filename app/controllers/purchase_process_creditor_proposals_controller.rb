class PurchaseProcessCreditorProposalsController < CrudController
  has_scope :licitation_process_id, allow_blank: true
  has_scope :creditor_id, allow_blank: true

  def destroy
    @creditor = Creditor.find(params[:creditor_id])
    @proposals = LicitationProcess.find(params[:licitation_process_id]).proposals_of_creditor(@creditor)
    respond_to do |format|
    if @proposals.destroy_all
      flash[:notice] = 'Proposta comercial deletada com sucesso!'
      format.html { redirect_to purchase_process_proposals_path(licitation_process_id: params[:licitation_process_id])}
      format.json{ render json: {}}
    else
      flash[:error] = 'Erro ao deletar Proposta comercial.!'
      format.html {redirect_to purchase_process_proposals_path(licitation_process_id: params[:licitation_process_id])}
      format.json{ render json: {}}
    end
    end
  end

end
