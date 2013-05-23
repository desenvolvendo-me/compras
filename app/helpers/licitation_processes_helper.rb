# encoding: utf-8
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

  def proposals_path
    link = "creditors_purchase_process_#{resource.judgment_form.kind}_creditor_proposals_path"
    send(link, licitation_process_id: resource)
  end

  def trading_path_helper
    if resource.has_trading?
      bids_purchase_process_trading_path(resource.trading)
    else
      new_purchase_process_trading_path(purchase_process_id: resource.id)
    end
  end
end
