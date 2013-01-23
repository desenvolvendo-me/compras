class TradingItemClosingDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes

  def after_create_path
    if trading_item.trading_allow_closing?
      routes.new_trading_closing_path(:trading_id => trading_item.trading_id)
    else
      routes.trading_items_path(:trading_id => trading_item.trading_id)
    end
  end
end
