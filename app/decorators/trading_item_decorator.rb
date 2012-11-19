class TradingItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper

  def unit_price
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def trading_item_bid_or_classification_path
    if component.finished_bid_stage?
      routes.classification_trading_item_path(component)
    else
      routes.new_trading_item_bid_path(:trading_item_id => component.id)
    end
  end
end
