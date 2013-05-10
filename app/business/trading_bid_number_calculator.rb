class TradingBidNumberCalculator
  def initialize(trading, item)
    @trading = trading
    @item    = item
  end

  def self.calculate(*args)
    new(*args).calculate_number
  end

  def calculate_number
    last_bid_number.succ
  end

  private

  def bid_numbers_by_item
    @trading.
      bids.
      not_without_proposal.
      by_item_id(@item.id).
      pluck(:number)
  end

  def last_bid_number
    bid_numbers_by_item.first || 0
  end
end
