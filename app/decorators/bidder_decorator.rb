class BidderDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def process_date
    localize component.licitation_process_process_date if component.licitation_process_process_date
  end

  def show_proposal_tabs
    if component.can_update_proposals?
      if component.licitation_process_lots.empty?
        'bidders/proposal_by_items'
      else
        'bidders/proposal_by_lots'
      end
    else
      { :text =>  t("other.compras.messages.to_add_proposals_all_items_must_belong_to_any_lot_or_any_lot_must_exist") }
    end
  end

  def proposal_total_value_by_lot(lot_id = nil)
    number_with_precision super
  end

  def proposal_total_value
    number_to_currency(super, :format => "%n") if super
  end

  def lower_trading_item_bid_amount(trading_item)
    number_with_precision super(trading_item) if super
  end

  def trading_item_classification_percent(trading_item)
    number_with_precision super(trading_item) if super
  end
end
