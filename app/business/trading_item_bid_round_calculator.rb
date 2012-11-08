class TradingItemBidRoundCalculator
  attr_accessor :trading_item

  delegate :trading_item_bids, :last_bid_round, :bidders, :to => :trading_item

  def initialize(trading_item)
    self.trading_item = trading_item
  end

  def calculate
    return last_bid_round unless all_bidders_have_bid_for_last_round?

    last_bid_round.succ
  end

  private

  def count_bids_with_proposal_for_last_round
    trading_item_bids.at_round(last_bid_round).with_proposal.count
  end

  def count_bidders_with_bids
    count_bids_with_proposal_for_last_round + bidders.with_no_proposal_for_trading_item(last_bid_round).count
  end

  def all_bidders_have_bid_for_last_round?
    last_bid_round == 0 || bidders.count == count_bidders_with_bids
  end
end
