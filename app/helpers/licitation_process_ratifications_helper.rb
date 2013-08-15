module LicitationProcessRatificationsHelper
  def creditor_proposals_helper_path(ratification)
    return purchase_process_items_path unless ratification.licitation_process_licitation?

    if ratification.judgment_form_item?
      trading_or_proposals_path(ratification)
    else
      realignment_price_items_path(purchase_process_id: ratification.licitation_process_id)
    end
  end

  private

  def trading_or_proposals_path(ratification)
    if ratification.licitation_process_trading?
      creditor_winner_items_purchase_process_trading_items_path
    else
      purchase_process_creditor_proposals_path
    end
  end
end
