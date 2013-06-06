class TradingBidRemover
  def initialize(item)
    @item = item
  end

  def self.undo(*args)
    new(*args).undo_last_bid
  end

  def undo_last_bid
    return unless last_bid

    if last_bid.benefited?
      last_bid.destroy
    else
      last_bid.update_attributes(
        status: TradingItemBidStatus::WITHOUT_PROPOSAL,
        amount: 0)
    end
  end

  private

  attr_reader :item

  def last_bid
    item.last_bid
  end
end
