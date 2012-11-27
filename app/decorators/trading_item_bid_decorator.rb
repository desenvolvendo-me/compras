class TradingItemBidDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def trading_item_last_proposal_value
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
end
