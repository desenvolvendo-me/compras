# encoding: utf-8
require 'unit_helper'
require 'enumerate_it'
require 'active_support/core_ext/module/delegation'
require "active_support/core_ext/date/calculations"
require 'app/enumerations/administrative_process_status'
require 'app/business/trading_item_bid_bidder_chooser'

describe TradingItemBidBidderChooser do
  subject do
    described_class.new(trading_item)
  end

  let(:trading_item) { double(:trading_item) }

  describe 'delegates' do
    it 'should delegate bidders to trading_item' do
      trading_item.should_receive(:bidders)

      subject.bidders
    end
  end

  describe '#choose' do
    context 'when round is equal 0' do
      it 'should choose first bidder when proposals have no one yet' do
        bidder1 = double(:bidder1)
        bidder2 = double(:bidder2)
        bidder3 = double(:bidder3)

        subject.stub(:current_round).and_return(0)

        subject.should_receive(:bidders_available).and_return([bidder1, bidder2, bidder3])
        subject.should_receive(:bidders_at_bid_round).with(0).and_return([])

        expect(subject.choose).to eq bidder1
      end

      it 'should choose next bidder when proposals have one bidder' do
        bidder1 = double(:bidder1)
        bidder2 = double(:bidder2)
        bidder3 = double(:bidder3)

        subject.stub(:current_round).and_return(0)

        subject.should_receive(:bidders_available).and_return([bidder1, bidder2, bidder3])
        subject.should_receive(:bidders_at_bid_round).with(0).and_return([bidder1])

        expect(subject.choose).to eq bidder2
      end

      it 'should choose next bidder when proposals have two bidder' do
        bidder1 = double(:bidder1)
        bidder2 = double(:bidder2)
        bidder3 = double(:bidder3)

        subject.stub(:current_round).and_return(0)

        subject.should_receive(:bidders_available).and_return([bidder1, bidder2, bidder3])
        subject.should_receive(:bidders_at_bid_round).with(0).and_return([bidder1, bidder2])

        expect(subject.choose).to eq bidder3
      end
    end

    context 'when round greater than 0' do
      it 'should choose first bidder when proposals have no one yet' do
        bidder1 = double(:bidder1)
        bidder2 = double(:bidder2)
        bidder3 = double(:bidder3)

        subject.stub(:current_round).and_return(1)

        subject.should_receive(:bidders).and_return([bidder1, bidder2, bidder3])
        subject.should_receive(:bidders_at_bid_round).with(1).and_return([])

        expect(subject.choose).to eq bidder1
      end

      it 'should choose next bidder when proposals have one bidder' do
        bidder1 = double(:bidder1)
        bidder2 = double(:bidder2)
        bidder3 = double(:bidder3)

        subject.stub(:current_round).and_return(1)

        subject.should_receive(:bidders).and_return([bidder1, bidder2, bidder3])
        subject.should_receive(:bidders_at_bid_round).with(1).and_return([bidder1])

        expect(subject.choose).to eq bidder2
      end

      it 'should choose next bidder when proposals have two bidder' do
        bidder1 = double(:bidder1)
        bidder2 = double(:bidder2)
        bidder3 = double(:bidder3)

        subject.stub(:current_round).and_return(1)

        subject.should_receive(:bidders).and_return([bidder1, bidder2, bidder3])
        subject.should_receive(:bidders_at_bid_round).with(1).and_return([bidder1, bidder2])

        expect(subject.choose).to eq bidder3
      end
    end
  end
end
