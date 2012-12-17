class TradingItemBidStageCalculator
  delegate :trading_item_bids, :bidders, :lowest_proposal_amount,
           :selected_bidders_at_proposals, :value_limit_to_participate_in_bids,
           :to => :trading_item

  def initialize(trading_item, trading_item_bidders = TradingItemBidders.new(trading_item, trading_item.bidders))
    @trading_item = trading_item
    @trading_item_bidders = trading_item_bidders
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

  def show_proposal_report?
    stage_of_round_of_bids? && trading_item_bids.at_stage_of_round_of_bids.empty?
  end

  private

  attr_reader :trading_item, :trading_item_bidders

  def all_bidders_have_proposal_for_proposals_stage?
    trading_item_bids.at_stage_of_proposals.count == bidders.count
  end

  def only_one_bidder_left_at_round_of_bids?
    return false unless trading_item_bids.at_stage_of_round_of_bids.any?

    trading_item_bids.at_stage_of_round_of_bids.with_no_proposal.count == trading_item_bidders.with_proposal_for_proposal_stage_with_amount_lower_than_limit_size - 1
  end
end
