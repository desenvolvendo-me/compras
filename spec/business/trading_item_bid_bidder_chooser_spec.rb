# encoding: utf-8
require 'unit_helper'
require 'enumerate_it'
require 'active_support/core_ext/module/delegation'
require "active_support/core_ext/date/calculations"
require 'app/enumerations/administrative_process_status'
require 'app/business/trading_item_bid_bidder_chooser'

describe TradingItemBidBidderChooser do
  subject do
    described_class.new(trading_item, trading_item_bidders)
  end

  let(:trading_item) { double(:trading_item) }
  let(:trading_item_bidders) { double(:trading_item_bidders) }

  describe '#choose' do
    context 'when I have 3 bidders' do
      let(:bidders) { [bidder1, bidder2, bidder3] }
      let(:bidder1) { double(:bidder1) }
      let(:bidder2) { double(:bidder2) }
      let(:bidder3) { double(:bidder3) }

      context 'when round is equal 0' do
        before do
          subject.stub(:current_round).and_return(0)
          trading_item.stub(:bidders).and_return(bidders)
        end

        it 'should choose first bidder when proposals have no one yet' do
          trading_item_bidders.stub(:at_bid_round).with(0).and_return([])

          expect(subject.choose).to eq bidder1
        end

        it 'should choose next bidder when proposals have one bidder' do
          trading_item_bidders.stub(:at_bid_round).with(0).and_return([bidder1])

          expect(subject.choose).to eq bidder2
        end

        it 'should choose next bidder when proposals have two bidder' do
          trading_item_bidders.stub(:at_bid_round).with(0).and_return([bidder1, bidder2])

          expect(subject.choose).to eq bidder3
        end
      end

      context 'when round is equal to 1' do
        before do
          subject.stub(:current_round).and_return(1)
          trading_item_bidders.should_receive(:with_proposal_for_proposal_stage_with_amount_lower_than_limit).and_return(bidders)
        end

        it 'should choose second bidder when proposals have no one yet' do
          trading_item_bidders.stub(:at_bid_round).with(1).and_return([])
          bidder1.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(100)
          bidder2.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(200)
          bidder3.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(300)

          expect(subject.choose).to eq bidder2
        end

        it 'should choose next bidder when proposals have one bidder' do
          trading_item_bidders.stub(:at_bid_round).with(1).and_return([bidder2])
          bidder1.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(100)
          bidder3.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(300)

          expect(subject.choose).to eq bidder3
        end

        it 'should choose next bidder when proposals have two bidder' do
          trading_item_bidders.stub(:at_bid_round).with(1).and_return([bidder2, bidder3])

          expect(subject.choose).to eq bidder1
        end
      end

      context 'when round is greater than 1' do
        before do
          subject.stub(:current_round).and_return(2)

          trading_item_bidders.stub(:with_proposal_for_round).with(1).and_return(bidders)
        end

        it 'should choose second bidder when proposals have no one yet' do
          trading_item_bidders.stub(:at_bid_round).with(2).and_return([])
          bidder1.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(100)
          bidder2.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(200)
          bidder3.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(300)

          expect(subject.choose).to eq bidder2
        end

        it 'should choose next bidder when proposals have one bidder' do
          trading_item_bidders.stub(:at_bid_round).with(2).and_return([bidder2])
          bidder1.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(100)
          bidder3.should_receive(:lower_trading_item_bid_amount).at_least(1).times.and_return(300)

          expect(subject.choose).to eq bidder3
        end

        it 'should choose next bidder when proposals have two bidder' do
          trading_item_bidders.stub(:at_bid_round).with(2).and_return([bidder2, bidder3])

          expect(subject.choose).to eq bidder1
        end
      end
    end
  end
end
