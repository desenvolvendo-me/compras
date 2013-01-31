require 'unit_helper'
require 'app/business/trading_item_bidders'

describe TradingItemBidders do
  subject do
    described_class.new(trading_item, bidders, :bidder_repository => bidder_repository)
  end

  let(:trading_item) { double(:trading_item, :id => -1) }
  let(:bidders) { double(:bidders) }
  let(:bidder_repository) { double(:bidder_repository) }

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
end
