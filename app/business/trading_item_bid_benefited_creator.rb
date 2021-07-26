class TradingItemBidBenefitedCreator
  def initialize(bid, options = {})
    @bid = bid
    @number_calculator = options.fetch(:number_calculator) { TradingBidNumberCalculator }
  end

  def self.create(*args)
    new(*args).create
  end

  def create
    bid.status = TradingItemBidStatus::WITH_PROPOSAL
    bid.round  = last_round
    bid.number = TradingBidNumberCalculator.calculate(item)
    bid.benefited = true

    bid
  end

  private

  attr_reader :bid, :number_calculator

  def item
    bid.item
  end

  def item_bids
    item.bids
  end

  def last_round
    item_bids.maximum(:round) || 0
  end
end
