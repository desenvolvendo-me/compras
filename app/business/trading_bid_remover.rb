class TradingBidRemover
  def initialize(item)
    @item = item
  end

  def self.undo(*args)
    new(*args).undo_last_bid
  end

  def undo_last_bid
    return unless last_bid

    last_bid.destroy

    bids_without_proposal.destroy_all
  end

  private

  attr_reader :item

  def last_bid
    item.last_bid
  end

  def bids_without_proposal
    item.bids.without_proposal
  end
end
