require 'spec_helper'

describe TradingItemsHelper do
  let(:resource) { double(:resource, :id => 1) }

  before do
    helper.stub(:resource).and_return(resource)
  end

  describe '#edit_trading_item_bid_proposal' do
    let(:bidder) { double(:bidder) }
    let(:trading_item_bid) { double(:trading_item_bid, :id => 15, :to_param => '15') }

    it 'should returns the path to edit the proposal of that bidder' do
      bidder.stub(:last_bid).and_return(trading_item_bid)

      expect(helper.edit_trading_item_bid_proposal(bidder)).to eq '/trading_item_bid_proposals/15/edit?trading_item_id=1'
    end
  end

  describe '#trading_item_closing_path' do
    context 'when closed' do
      let(:closing) { double(:closing, :to_param => "3")}

      before do
        resource.stub(:closed? => true)
        resource.stub(:closing => closing)
      end

      it 'should returns path to edit the trading_item_closing' do
        expect(helper.trading_item_closing_path).to eq '/trading_item_closings/3/edit'
      end
    end

    context 'when closed' do
      before do
        resource.stub(:closed? => false)
      end

      it 'should returns path to edit the trading_item_closing' do
        expect(helper.trading_item_closing_path).to eq '/trading_item_closings/new?trading_item_id=1'
      end
    end
  end
end
