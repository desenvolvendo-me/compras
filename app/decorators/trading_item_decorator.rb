# encoding: utf-8
class TradingItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def unit_price
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def current_stage_path(routes, options={})
    stage_calculator = options.fetch(:stage_calculator) {
      TradingItemBidStageCalculator.new(component)
    }

    stage_of_proposals_path(routes, stage_calculator) ||
    round_of_bids_or_proposal_report_path(routes, stage_calculator) ||
    routes.classification_trading_item_path(component)
  end

  def situation_for_next_stage(bidder, bidder_selector = TradingItemBidderSelector)
    if bidder_selected?(bidder, bidder_selector)
      t('trading_item.messages.selected')
    else
      t('trading_item.messages.not_selected')
    end
  end

  def allows_offer_placing
    must_have_minimum_reduction || must_be_open || must_have_only_one_item_started
  end

  def any_bid_at_negotiation?
    bids.at_stage_of_negotiation.any?
  end

  def cannot_undo_last_offer_message
    if closed?
      t('trading_item.messages.cannot_undo_last_offer_when_trading_items_is_closed')
    elsif bidder_disabled_for_last_bid?
      t('trading_item.messages.cannot_undo_a_bid_of_disabled_bidder',
        :stage => 'oferta', :bidder => bidder_for_last_bid)
    end
  end

  def cannot_undo_last_negotiation_message
    if closed?
      t('trading_item.messages.cannot_undo_last_negotiation_when_trading_items_is_closed')
    elsif bidder_disabled_for_last_bid?
      t('trading_item.messages.cannot_undo_a_bid_of_disabled_bidder',
        :stage => 'negociação', :bidder => bidder_for_last_bid)
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

    if bidders_enabled_not_selected.empty?
      t('trading_item.messages.without_proposals_not_selected')
    else
      t('trading_item.messages.there_is_bidders_enabled')
    end
  end

  def current_bidder_for_negotiation?(bidder)
    bidder == remaining_bidders_for_negotiation.first
  end

  def last_negotiation
    bids.at_stage_of_negotiation.last
  end

  def last_bidder_for_negotiation?(bidder)
    return unless last_negotiation

    last_negotiation.bidder == bidder
  end

  private

  def round_of_bids_or_proposal_report_path(routes, stage_calculator)
    if stage_calculator.stage_of_proposal_report?
      routes.proposal_report_trading_item_path(component)
    elsif stage_calculator.stage_of_round_of_bids?
      routes.new_trading_item_bid_round_of_bid_path(:trading_item_id => component.id)
    end
  end

  def stage_of_proposals_path(routes, stage_calculator)
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
    trading.items.each do |item|
      if item.started? && !item.closed?
        if component != item
          return t('trading_item.messages.there_is_an_pending_item', :trading_item => item)
        end
      end
    end

    nil
  end

  def bidder_selected?(bidder, bidder_selector)
    bidders_selected(bidder_selector).include? bidder
  end

  def bidders_selected(bidder_selector)
    bidder_selector.selected(component)
  end

  def bidder_disabled_for_last_bid?
    return unless last_bid

    bidder_for_last_bid.disabled
  end

  def bidder_for_last_bid
    last_bid.bidder
  end

  def allow_negotiation?
    remaining_bidders_for_negotiation.any?
  end

  def remaining_bidders_for_negotiation
    TradingItemBidderNegotiationSelector.new(component).remaining_bidders
  end
end
