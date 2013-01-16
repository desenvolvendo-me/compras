class TradingItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def unit_price
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def trading_item_closing_path
    if closed?
      routes.edit_trading_item_closing_path(closing)
    else
      routes.new_trading_item_closing_path(:trading_item_id => id)
    end
  end

  def current_stage_path(options={})
    stage_calculator = options.fetch(:stage_calculator) {
      TradingItemBidStageCalculator.new(component)
    }

    stage_of_proposals_path(stage_calculator) ||
    round_of_bids_or_proposal_report_path(stage_calculator) ||
    negotiation_or_classification_path(stage_calculator)
  end

  def situation_for_next_stage(bidder)
    if bidder_selected?(bidder)
      t('trading_item.messages.selected')
    else
      t('trading_item.messages.not_selected')
    end
  end

  def allows_offer_placing
    must_have_minimum_reduction || must_be_open || must_have_only_one_item_started
  end

  def any_bid_at_negotiation?
    trading_item_bids.at_stage_of_negotiation.any?
  end

  def cannot_undo_last_offer_message
    if closed?
      t('trading_item.messages.cannot_undo_last_offer_when_trading_items_is_closed')
    end
  end

  def cannot_undo_last_negotiation_message
    if closed?
      t('trading_item.messages.cannot_undo_last_negotiation_when_trading_items_is_closed')
    end
  end

  def cannot_start_negotiation_message
    return if allow_negotiation?

    t('trading_item.messages.cannot_start_negotiation')
  end

  def not_allow_offer_message
    return if with_proposal_for_round_of_proposals?

    t('trading_item.messages.not_allow_offer')
  end

  def cannot_activate_proposals_message
    return if activate_proposals_allowed?

    t('trading_item.messages.cannot_activate_proposals')
  end

  private

  def negotiation_or_classification_path(stage_calculator)
    if stage_calculator.stage_of_negotiation?
      if trading_item_bids.negotiation.empty? || !valid_bidder_for_negotiation?
        routes.classification_trading_item_path(component)
      else
        routes.new_trading_item_bid_negotiation_path(:trading_item_id => component.id)
      end
    end
  end

  def round_of_bids_or_proposal_report_path(stage_calculator)
    if stage_calculator.stage_of_round_of_bids?
      if trading_item_bids.at_stage_of_round_of_bids.empty?
        routes.proposal_report_trading_item_path(component)
      else
        routes.new_trading_item_bid_round_of_bid_path(:trading_item_id => component.id)
      end
    end
  end

  def stage_of_proposals_path(stage_calculator)
    if stage_calculator.stage_of_proposals?
      routes.new_trading_item_bid_proposal_path(:trading_item_id => component.id)
    end
  end

  def must_have_minimum_reduction
    return if minimum_reduction_percent > 0 || minimum_reduction_value > 0

    t('trading_item.messages.must_have_reduction')
  end

  def must_be_open
    return unless closed?

    t('trading_item.messages.must_be_open')
  end

  def must_have_only_one_item_started
    trading.trading_items.each do |item|
      if item.started? && !item.closed?
        if component != item
          return t('trading_item.messages.there_is_an_pending_item', :trading_item => item)
        end
      end
    end

    nil
  end

  def bidder_selected?(bidder)
    selected_for_trading_item.include? bidder
  end

  def selected_for_trading_item
    component.bidders.selected_for_trading_item(component)
  end
end
