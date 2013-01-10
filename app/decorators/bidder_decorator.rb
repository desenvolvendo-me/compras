# encoding: utf-8
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

  def lower_trading_item_bid_amount(*)
    return if component.disabled

    number_with_precision super if super
  end

  def lower_trading_item_bid_amount_at_stage_of_proposals(*)
    return if component.disabled

    number_with_precision super if super
  end

  def trading_item_classification_percent(*)
    return if component.disabled

    number_with_precision super if super
  end

  def last_amount_valid_for_trading_item_at_stage_of_round_of_bids(*)
    number_with_precision super if super
  end

  def last_amount_valid_for_trading_item_at_stage_of_negotiation(*)
    number_with_precision super if super
  end

  def benefited_by_law_of_proposals_class(trading_item)
    if component.benefited_by_law_of_proposals? && valid_benefited_percent?(trading_item)
      'benefited'
    else
      'not-benefited'
    end
  end

  def cant_save_or_destroy_message
    if licitation_process_ratification?
      t('bidder.messages.cant_be_changed_when_licitation_process_has_a_ratification')
    elsif !allow_bidders?
      t('bidder.messages.cant_save_or_destroy')
    end
  end

  def benefited
    if component.benefited
      t('true')
    else
      t('false')
    end
  end

  def last_status(trading_item)
    return unless last_bid(trading_item).present?

    last_bid(trading_item).status_humanize
  end

  def status_for_negotiation(trading_item)
    if last_bid(trading_item).negotiation?
      last_bid(trading_item).status_humanize
    else
      'À negociar'
    end
  end

  private

  def valid_benefited_percent?(trading_item, percent = 5.0)
    return if component.trading_item_classification_percent(trading_item).nil?
    component.trading_item_classification_percent(trading_item) <= percent
  end
end
