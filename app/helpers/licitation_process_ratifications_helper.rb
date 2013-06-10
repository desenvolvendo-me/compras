module LicitationProcessRatificationsHelper
  def creditor_proposals_helper_path(ratification)
    if ratification.licitation_process_licitation?
      if ratification.judgment_form_item?
        purchase_process_creditor_proposals_path
      else
        realigment_prices_path
      end
    else
      purchase_process_items_path
    end
  end
end
