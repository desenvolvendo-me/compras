module LicitationProcessesHelper
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

    if !resource.publications.current_updateable?
      t('licitation_process.messages.no_one_publication_with_valid_type', :publication_of => resource.publications.current.publication_of_humanize)
    elsif resource.licitation_process_ratifications.any?
      t('licitation_process.messages.has_already_a_ratification')
    end
  end
end
