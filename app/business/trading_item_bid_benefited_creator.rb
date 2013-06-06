class TradingItemBidBenefitedCreator
  def initialize(bid)
    @bid = bid
  end

  def self.create(*args)
    new(*args).create
  end

  def create
    bid.status = TradingItemBidStatus::WITH_PROPOSAL
    bid.round  = last_round
    bid.number = last_number.succ
    bid.benefited = true

    bid
  end

  private

  attr_reader :bid

  def item
    bid.item
  end

  def item_bids
    item.bids
  end

  def last_round
    item_bids.maximum(:round) || 0
  end

  def last_number
    item_bids.maximum(:number) || 0
  end
end
