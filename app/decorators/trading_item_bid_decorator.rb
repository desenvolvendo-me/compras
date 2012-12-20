class TradingItemBidDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def trading_item_lowest_proposal_value
    number_with_precision super if super
  end

  def minimum_limit
    number_with_precision super if super
  end

  def form_partial(stage_calculator = TradingItemBidStageCalculator)
    if stage_calculator.new(component.trading_item).stage_of_proposals?
      'form_of_proposal'
    else
      'form'
    end
  end

  def new_title(stage_calculator = TradingItemBidStageCalculator)
    if stage_calculator.new(trading_item).stage_of_negotiation?
      t('trading_item_bid_negotiations.new')
    else
      t('trading_item_bid_round_of_bids.new')
    end
  end

  def show_undo_button?
    trading_item.proposals_for_round_of_bids?
  end
end
