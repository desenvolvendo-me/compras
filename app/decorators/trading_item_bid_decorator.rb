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
end
