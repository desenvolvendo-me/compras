require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/trading_item_bid_round_calculator'

describe TradingItemBidRoundCalculator do
  subject do
    described_class.new(trading_item)
  end

  let(:trading_item) { double(:trading_item) }

  describe 'delegates' do
    it 'delegates trading_item_bids to trading_item' do
      trading_item.should_receive(:trading_item_bids)

      subject.trading_item_bids
    end

    it 'delegates available_bidders to trading_item' do
      trading_item.should_receive(:available_bidders)

      subject.available_bidders
    end

    it 'delegates last_bid_round to trading_item' do
      trading_item.should_receive(:last_bid_round)

      subject.last_bid_round
    end
  end

  context '#calculate' do
    it 'should return next round when all bidders have bid for the round' do
      trading_item_bids = double(:trading_item_bids)

      trading_item.stub(:last_bid_round).and_return(1)
      trading_item.stub(:trading_item_bids).and_return(trading_item_bids)
      trading_item.stub(:available_bidders).and_return(['bidder1', 'bidder2'])

      trading_item_bids.should_receive(:at_round).with(1).and_return(['item1', 'item2'])

      expect(subject.calculate).to eq 2
    end

    it 'should return current round when not all bidders have bid for the round' do
      trading_item_bids = double(:trading_item_bids)

      trading_item.stub(:last_bid_round).and_return(1)
      trading_item.stub(:trading_item_bids).and_return(trading_item_bids)
      trading_item.stub(:available_bidders).and_return(['bidder1', 'bidder2'])

      trading_item_bids.should_receive(:at_round).with(1).and_return(['item1'])

      expect(subject.calculate).to eq 1
    end

    it 'should return 1 when there are no bids yet' do
      trading_item.stub(:last_bid_round).and_return(0)

      expect(subject.calculate).to eq 1
    end
  end
end
