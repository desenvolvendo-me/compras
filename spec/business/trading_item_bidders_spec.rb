require 'unit_helper'
require 'app/business/trading_item_bidders'

describe TradingItemBidders do
  subject do
    described_class.new(trading_item, bidders)
  end

  let(:trading_item) { double(:trading_item, :id => -1) }
  let(:bidders) { double(:bidders) }

  it '#with_proposal_for_proposal_stage_with_amount_lower_than_limit' do
    bidders.should_receive(:with_proposal_for_proposal_stage_with_amount_lower_than_limit).with(trading_item)

    subject.with_proposal_for_proposal_stage_with_amount_lower_than_limit
  end

  it '#with_proposal_for_proposal_stage_with_amount_lower_than_limit_size' do
    with_proposal_for_proposal_stage_with_amount_lower_than_limit = double(:with_proposal_for_proposal_stage_with_amount_lower_than_limit)
    subject.stub(:with_proposal_for_proposal_stage_with_amount_lower_than_limit).and_return(with_proposal_for_proposal_stage_with_amount_lower_than_limit)
    with_proposal_for_proposal_stage_with_amount_lower_than_limit.should_receive(:size).at_least(1).times

    subject.with_proposal_for_proposal_stage_with_amount_lower_than_limit_size
  end

  it '#with_proposal_for_round' do
    round = double(round)
    bidders.should_receive(:with_proposal_for_trading_item_round).with(round)

    subject.with_proposal_for_round(round)
  end

  it '#at_bid_round' do
    round = double(round)
    bidders.should_receive(:at_bid_round).with(round, trading_item.id)

    subject.at_bid_round(round)
  end

  it '#for_stage_of_round_of_bids' do
    round_of_bids = double(round_of_bids)
    bidders.should_receive(:at_trading_item_stage).with(trading_item, round_of_bids)

    subject.for_stage_of_round_of_bids(round_of_bids)
  end
end
