class LicitationProcessBidderDecorator < Decorator
  def process_date
    helpers.l component.licitation_process_process_date if component.licitation_process_process_date
  end

  def show_proposal_tabs
    if component.can_update_proposals?
      if component.licitation_process_lots.empty?
        'licitation_process_bidders/proposal_by_items'
      else
        'licitation_process_bidders/proposal_by_lots'
      end
    else
      { :text =>  helpers.t("other.compras.messages.to_add_proposals_all_items_must_belong_to_any_lot_or_any_lot_must_exist") }
    end
  end

  def proposal_total_value_by_lot(lot_id)
    helpers.number_with_precision super
  end

  def proposal_total_value
    helpers.number_to_currency(super, :format => "%n") if super
  end
end
