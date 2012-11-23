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

  def trading_item_bid_or_classification_path(stage_calculator = TradingItemBidStageCalculator)
    if stage_calculator.new(component).stage_of_negotiation?
      routes.classification_trading_item_path(component)
    else
      routes.new_trading_item_bid_path(:trading_item_id => component.id)
    end
  end

  def trading_item_bid_or_classification_or_report_classification_path(stage_calculator = TradingItemBidStageCalculator)
    if stage_calculator.new(component).show_proposal_report?
      routes.proposal_report_trading_item_path(component)
    else
      trading_item_bid_or_classification_path(stage_calculator)
    end
  end

  def situation_for_next_stage(bidder)
    if bidder_selected?(bidder)
      t('trading_item.messages.selected')
    else
      t('trading_item.messages.not_selected')
    end
  end

  private

  def bidder_selected?(bidder)
    bidders_with_proposal_for_proposal_stage_with_amount_lower_than_limit.include? bidder
  end

  def value_limit_to_participate_in_bids
    component.value_limit_to_participate_in_bids
  end

  def bidders_with_proposal_for_proposal_stage_with_amount_lower_than_limit
    component.bidders.with_proposal_for_proposal_stage_with_amount_lower_than_limit(value_limit_to_participate_in_bids)
  end
end
