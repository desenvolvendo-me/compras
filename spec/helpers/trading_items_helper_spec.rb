require 'spec_helper'

describe TradingItemsHelper do
  let(:resource) { double(:resource, :id => 1) }

  before do
    helper.stub(:resource).and_return(resource)
  end

  describe '#new_trading_item_bid_with_anchor' do
    it 'should returns link to trading_item_bid with anchor to title' do
      expect(helper.new_trading_item_bid_with_anchor).to eq '/trading_item_bids/new?trading_item_id=1#title'
    end
  end
end
