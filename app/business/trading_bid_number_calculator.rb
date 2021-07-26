class TradingBidNumberCalculator
  def initialize(item)
    @item = item
  end

  def self.calculate(*args)
    new(*args).calculate_number
  end

  def calculate_number
    last_bid_number.succ
  end

  private

  attr_reader :item

  def bid_numbers_by_item
    item.
      bids.
      not_without_proposal.
      by_item_id(item.id).
      pluck(:number)
  end

  def last_bid_number
    bid_numbers_by_item.first || 0
  end
end
