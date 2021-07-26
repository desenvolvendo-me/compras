module LicitationProcessesHelper
  include RealignmentPricesHelper
  include LicitationProcessRatificationsHelper
  include PurchaseProcessTradingsHelper

  def classification_link
    return unless resource.persisted?

    link_to('Relatório', licitation_process_path(resource), :class => "button secondary") unless resource.all_licitation_process_classifications.empty?
  end

  def accreditation_path_helper
    return unless resource.persisted?

    if resource.purchase_process_accreditation.present?
      edit_purchase_process_accreditation_path(resource.purchase_process_accreditation, :licitation_process_id => resource.id)
    else
      new_purchase_process_accreditation_path(:licitation_process_id => resource.id)
    end
  end

  def trading_path_helper
    if resource.has_trading?
      bids_purchase_process_trading_path(resource.trading)
    else
      new_purchase_process_trading_path(purchase_process_id: resource.id)
    end
  end

  def judgment_commission_advice
    if resource.judgment_commission_advice
      edit_judgment_commission_advice_path(resource.judgment_commission_advice)
    else
      new_judgment_commission_advice_path(licitation_process_id: resource.id)
    end
  end

  def minute_purchase_process_link
    unless resource.judgment_commission_advice.nil?
      if resource.trading?
        link_to('Imprimir ATA', report_minute_purchase_process_tradings_path(resource.id), class: "button primary")
      else
        link_to('Imprimir ATA', report_minute_purchase_processes_path(resource.id), class: "button primary")
      end
    end
  end

  def not_updateable_message
    return if (resource.updateable? && resource.persisted?)

    if resource.licitation_process_ratifications.reject(&:new_record?).any?
      t('licitation_process.messages.has_already_a_ratification')
    end
  end

  def publication_of_collection(licitation_process)
    if licitation_process.simplified_processes?
      PublicationOf.allowed_for_direct_purchase
    else
      PublicationOf.to_a.sort { |a,b| a[0] <=> b[0] }
    end
  end

  def qualified_creditor licitation_process
    if licitation_process.try(:licitation?)
      creditors_path
    else
      creditors_path(by_bidders: licitation_process.id)
    end
  end

  def view_or_edit_creditor_proposal(creditor)
    if resource.proposals_of_creditor(creditor).empty?
      link_to 'Cadastrar propostas',
              new_purchase_process_proposal_path(licitation_process_id: resource.id, creditor_id: creditor.id)
    else
      link_to 'Editar propostas',
              edit_purchase_process_proposal_path(resource, creditor_id: creditor.id)
    end
  end

  def link_to_disqualify_creditor_proposal(creditor)
    if resource.proposals_of_creditor(creditor).any?
      link_to "Desclassificar propostas", disqualify_creditor_proposal_path(creditor)
    else
      'Nenhuma proposta cadastrada'
    end
  end

  def disqualification_status_message(creditor)
    I18n.t("other.compras.messages.#{disqualification_status(creditor)}")
  end

  def initialize_trading purchase_process
    trading = TradingCreator.create!(purchase_process)
    trading = trading.present? ? trading : purchase_process.trading

    trading
  end


  private

  def disqualification_status(creditor)
    PurchaseProcessCreditorDisqualification.disqualification_status(resource.id, creditor.id)
  end

  def disqualify_creditor_proposal_path(creditor)
    object = PurchaseProcessCreditorDisqualification.by_licitation_process_and_creditor(resource.id, creditor.id).first

    if object.nil?
      new_purchase_process_creditor_disqualification_path({
                                                              licitation_process_id: resource.id, creditor_id: creditor.id
                                                          })
    else
      edit_purchase_process_creditor_disqualification_path object
    end
  end

  def edit_title
    I18n.t("activerecord.models.licitation_process.one")
  end
end
