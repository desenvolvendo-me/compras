require 'unit_helper'
require 'app/business/trading_item_bidders'

describe TradingItemBidders do
  subject do
    described_class.new(trading_item, bidders, :bidder_repository => bidder_repository)
  end

  let(:trading_item) { double(:trading_item, :id => -1) }
  let(:bidders) { double(:bidders) }
  let(:bidder_repository) { double(:bidder_repository) }

  it '#selected_for_trading_item' do
    bidders.should_receive(:selected_for_trading_item).with(trading_item)

    subject.selected_for_trading_item
  end

  it '#selected_for_trading_item_size' do
    selected_for_trading_item = double(:selected_for_trading_item)
    subject.stub(:selected_for_trading_item).and_return(selected_for_trading_item)
    selected_for_trading_item.should_receive(:size).at_least(1).times

    subject.selected_for_trading_item_size
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
