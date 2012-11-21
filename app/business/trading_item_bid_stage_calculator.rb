class TradingItemBidStageCalculator
  attr_accessor :trading_item

  delegate :trading_item_bids, :bidders, :lowest_proposal_amount,
           :to => :trading_item

  def initialize(trading_item)
    self.trading_item = trading_item
  end

  def stage_of_proposals?
    trading_item_bids.empty? || !all_bidders_have_proposal_for_proposals_stage?
  end

  def stage_of_negotiation?
     !stage_of_proposals? && only_one_bidder_left_at_round_of_bids? && lowest_proposal_amount
  end

  def stage_of_round_of_bids?
    !stage_of_proposals? && !stage_of_negotiation?
  end

  private

  def all_bidders_have_proposal_for_proposals_stage?
    trading_item_bids.at_stage_of_proposals.count == bidders.count
  end

  def only_one_bidder_left_at_round_of_bids?
    trading_item_bids.at_stage_of_round_of_bids.with_no_proposal.count == selected_bidders.size - 1
  end

  def selected_bidders
    trading_item_bids.with_proposal.at_stage_of_proposals.map(&:bidder)
  end
end
