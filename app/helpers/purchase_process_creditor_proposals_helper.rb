# encoding: utf-8

module PurchaseProcessCreditorProposalsHelper
  def view_or_edit_creditor_proposal(creditor)
    if @licitation_process.creditor_proposals_of_creditor(creditor).empty?
      link_to 'Cadastrar Propostas', new_purchase_process_creditor_proposal_path(creditor_id: creditor,
        licitation_process_id: @licitation_process)
    else
      link_to 'Editar Propostas', batch_edit_purchase_process_creditor_proposals_path(creditor_id: creditor,
        licitation_process_id: @licitation_process)
    end
  end

  def collection_for_association(creditor_proposals)
    creditor_id = params[:creditor_id].to_i

    creditor    = creditor_proposals.select(&:new_record?).first
    creditor  ||= creditor_proposals.select { |c| c.creditor_id == creditor_id }.first
    creditor  ||= creditor_proposals.where(creditor_id: creditor_id).first
    creditor  ||= creditor_proposals.build(creditor_id: creditor_id)

    creditor
  end

  def form_path
    if ["batch_edit", "batch_update"].include? params[:action]
      { :url => batch_update_purchase_process_creditor_proposals_path, :method => :put }
    else
      { :url => purchase_process_creditor_proposals_path, :method => :post }
    end
  end
end
