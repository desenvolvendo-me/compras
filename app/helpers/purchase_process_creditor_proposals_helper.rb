# encoding: utf-8
module PurchaseProcessCreditorProposalsHelper
  def title
    "Proposta Comercial Processo #{@licitation_process.to_s}"
  end

  def new_title
    "Criar Proposta Comercial"
  end

  def edit_title
    "Editar Proposta Comercial"
  end

  def subtitle
    "Fornecedor #{@creditor} - Processo #{licitation_process_object}"
  end

  def form_partial
    "form_#{licitation_process_object.judgment_form_kind}"
  end

  def update_path
    url_for(controller: :purchase_process_creditor_proposals, action: :update, id: licitation_process_object.id)
  end

  def creditor_proposals_collection
    @proposals || resource.creditor_proposals.select { |p| p.creditor_id == @creditor.id }
  end

  def view_or_edit_creditor_proposal(creditor)
    if @licitation_process.proposals_of_creditor(creditor).empty?
      link_to 'Cadastrar propostas',
        new_purchase_process_creditor_proposal_path(licitation_process_id: @licitation_process.id, creditor_id: creditor.id)
    else
      link_to 'Editar propostas',
        edit_purchase_process_creditor_proposal_path(@licitation_process, creditor_id: creditor.id)
    end
  end

  def link_to_disqualify_creditor_proposal(creditor)
    if @licitation_process.proposals_of_creditor(creditor).any?
      link_to "Desclassificar propostas", disqualify_creditor_proposal_path(creditor)
    else
      'Nenhuma proposta cadastrada'
    end
  end

  def disqualification_status_message(creditor)
    I18n.t("other.compras.messages.#{disqualification_status(creditor)}")
  end

  private

  def licitation_process_object
    @licitation_process || resource
  end

  def disqualification_status(creditor)
    PurchaseProcessCreditorDisqualification.disqualification_status(@licitation_process.id, creditor.id)
  end

  def disqualify_creditor_proposal_path(creditor)
    object = PurchaseProcessCreditorDisqualification.by_licitation_process_and_creditor(@licitation_process.id, creditor.id).first

    if object.nil?
      new_purchase_process_creditor_disqualification_path({
        licitation_process_id: @licitation_process.id, creditor_id: creditor.id
      })
    else
      edit_purchase_process_creditor_disqualification_path object
    end
  end
end
