class TradingItemBidStageCalculator
  delegate :bids, :bidders, :lowest_proposal_amount,
           :selected_bidders_at_proposals,
           :to => :trading_item

  def initialize(trading_item, options = {})
    @trading_item = trading_item
    @bidder_selector = options.fetch(:bidder_selector) { TradingItemBidderSelector }
    @bidder_negotiation_selector = options.fetch(:bidder_negotiation_selector) { TradingItemBidderNegotiationSelector.new(trading_item) }
  end

  def stage_of_proposals?
    bids.empty? || !all_bidders_have_proposal_for_proposals_stage?
  end

  def stage_of_negotiation?
     !stage_of_proposals? && only_one_bidder_left_at_round_of_bids? && lowest_proposal_amount
  end

  def stage_of_round_of_bids?
    !stage_of_proposals? && !stage_of_negotiation?
  end

  def stage_of_proposal_report?
    stage_of_round_of_bids? && bids.at_stage_of_round_of_bids.empty?
  end

  def stage_of_classification?
    stage_of_negotiation? && (bids.negotiation.empty? || !valid_bidder_for_negotiation?)
  end

  private

  attr_reader :trading_item, :bidder_selector, :bidder_negotiation_selector

  def all_bidders_have_proposal_for_proposals_stage?
    bids.at_stage_of_proposals.count >= bidders.enabled.count
  end

  def only_one_bidder_left_at_round_of_bids?
    return false unless bids.at_stage_of_round_of_bids.any?

    bids.at_stage_of_round_of_bids.with_no_proposal.count == bidder_selector.selected(trading_item).count - 1
  end

  def valid_bidder_for_negotiation?
    bidder_negotiation_selector.remaining_bidders.any?
  end
end
