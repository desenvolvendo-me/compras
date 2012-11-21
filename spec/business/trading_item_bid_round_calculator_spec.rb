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

    it 'delegates bidders to trading_item' do
      trading_item.should_receive(:bidders)

      subject.bidders
    end
  end

  describe '#calculate' do
    it 'should return 1 when there are no bids' do
      trading_item.stub(:last_bid_round).and_return(0)

      expect(subject.calculate).to eq 1
    end

    it 'should return current_round when not all bidders have proposals' do
      last_bid = double(:last_bid, :round => 2)

      subject.should_receive(:last_bid).twice.and_return(last_bid)
      subject.should_receive(:all_bidders_have_bid_for_last_round?).
              and_return(false)

      expect(subject.calculate).to eq 2
    end

    it 'should return next_round when all bidders have proposals' do
      last_bid = double(:last_bid, :round => 2)

      subject.should_receive(:last_bid).twice.and_return(last_bid)
      subject.stub(:stage_of_round_of_bids?).and_return(true)
      subject.should_receive(:all_bidders_have_bid_for_last_round?).
              and_return(true)

      expect(subject.calculate).to eq 3
    end
  end
end
