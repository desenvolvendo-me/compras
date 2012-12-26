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
      bidder.stub(:lower_trading_item_bid).and_return(trading_item_bid)

      expect(helper.edit_trading_item_bid_proposal(bidder)).to eq '/trading_item_bid_proposals/15/edit?trading_item_id=1'
    end
  end
end
