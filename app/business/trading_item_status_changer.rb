class TradingItemStatusChanger
  def initialize(item, options = {})
    @item = item
    @trading_item_winner = options.fetch(:trading_item_winner) { TradingItemWinner }
  end

  def self.change(*args)
    new(*args).change
  end

  def change
    if trading_item_winner.new(item).creditor
      item.close! unless item.closed?
    else
      item.pending! unless item.pending?
    end
  end

  private

  attr_reader :item, :trading_item_winner
end
