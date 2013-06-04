class TradingBidCleaner
  def initialize(item, options = {})
    @item = item
    @next_bid_calculator = options.fetch(:next_bid_calculator) { NextBidCalculator }
  end

  def self.clean(*args)
    new(*args).clean_bids
  end

  def clean_bids
    return if next_bid

    bids_without_proposal.destroy_all
  end

  private

  attr_reader :item, :next_bid_calculator

  def next_bid
    next_bid_calculator.next_bid(item)
  end

  def bids_without_proposal
    item.bids.without_proposal
  end
end
