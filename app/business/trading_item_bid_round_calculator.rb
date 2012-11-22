class TradingItemBidRoundCalculator
  attr_accessor :trading_item

  delegate :trading_item_bids, :bidders, :selected_bidders_at_proposals,
           :to => :trading_item

  def initialize(trading_item)
    self.trading_item = trading_item
  end

  def calculate
    return last_bid_round unless next_last_bid_round?

    last_bid_round.succ
  end

  private

  def count_bids_with_proposal_for_last_round
    trading_item_bids_for_stage_of_round_of_bids.at_round(last_bid_round).with_proposal.count
  end

  def count_bidders_with_bids
    count_bids_with_proposal_for_last_round + bidders_for_stage_of_round_of_bids.with_no_proposal_for_trading_item(trading_item.id).count
  end

  def all_bidders_have_bid_for_last_round?
    last_bid.nil? || selected_bidders_at_proposals.count == count_bidders_with_bids
  end

  def bidders_for_stage_of_round_of_bids
    bidders.at_trading_item_stage(trading_item, TradingItemBidStage::ROUND_OF_BIDS)
  end

  def trading_item_bids_for_stage_of_round_of_bids
    trading_item_bids.at_stage_of_round_of_bids
  end

  def next_last_bid_round?
    all_bidders_have_bid_for_last_round? && stage_of_round_of_bids?
  end

  def stage_of_round_of_bids?(stage_calculator = TradingItemBidStageCalculator)
    stage_calculator.new(trading_item).stage_of_round_of_bids?
  end

  def last_bid
    trading_item_bids_for_stage_of_round_of_bids.last
  end

  def last_bid_round
    last_bid.nil? ? 0 : last_bid.round
  end
end
