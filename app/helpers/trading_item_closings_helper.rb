# encoding: utf-8
module TradingItemClosingsHelper
  def edit_title(trading_item = @trading_item)
    "Encerramento do Item do Pregão #{trading_item.trading}"
  end
end
