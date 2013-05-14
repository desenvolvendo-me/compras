# encoding: utf-8
module PurchaseProcessCreditorProposalsHelper
  def view_or_edit_creditor_proposal(creditor)
    if @licitation_process.proposals_of_creditor(creditor).empty?
      link_to 'Cadastrar propostas', @proposal_path_generator.new_proposal_path(creditor)
    else
      link_to 'Editar propostas', @proposal_path_generator.edit_proposal_path(creditor)
    end
  end

  def link_to_disqualify_creditor_proposal(creditor)
    if @licitation_process.proposals_of_creditor(creditor).any?
      link_to "Desclassificar propostas", @proposal_path_generator.disqualify_proposal_path(creditor)
    else
      'Nenhuma proposta cadastrada'
    end
  end

  def creditors_proposals_url
    @proposal_path_generator.proposals_path
  end

  def form_path
    @proposal_path_generator.form_proposal_path params[:action]
  end

  def disqualification_status(creditor)
    status = PurchaseProcessCreditorDisqualification.disqualification_status(@licitation_process.id, creditor.id)
    I18n.t("other.compras.messages.#{status}")
  end
end
