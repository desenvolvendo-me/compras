class TradingItemBidRoundCalculator
  delegate :bids, :selected_bidders_at_proposals, :bidders,
           :to => :trading_item

  def initialize(trading_item, options = {})
    @trading_item = trading_item
    @stage_calculator = options.fetch(:stage_calculator) { TradingItemBidStageCalculator }
  end

  def calculate(stage = nil)
    return 0 if stage == TradingItemBidStage::NEGOTIATION
    return last_bid_round unless next_last_bid_round?

    last_bid_round.succ
  end

  private

  attr_reader :trading_item, :stage_calculator

  def count_bids_with_proposal_for_last_round
    trading_item_bids_for_stage_of_round_of_bids.at_round(last_bid_round).with_proposal.count
  end

  def count_bidders_with_bids
    count_bids_with_proposal_for_last_round + bidders.at_round_of_bids(trading_item).with_no_proposal_for_trading_item(trading_item.id).count
  end

  def all_bidders_have_bid_for_last_round?
    return true if last_bid.nil?

    if last_bid_round > 0
      trading_item_bidders.selected_for_trading_item.count == count_bidders_with_bids
    else
      selected_bidders_at_proposals.count == count_bidders_with_bids
    end
  end

  def trading_item_bids_for_stage_of_round_of_bids
    bids.at_stage_of_round_of_bids
  end

  def next_last_bid_round?
    all_bidders_have_bid_for_last_round? && stage_of_round_of_bids?
  end

  def stage_of_round_of_bids?
    stage_calculator.new(trading_item).stage_of_round_of_bids?
  end

  def last_bid
    trading_item_bids_for_stage_of_round_of_bids.last
  end

  def last_bid_round
    last_bid.nil? ? 0 : last_bid.round
  end
end
