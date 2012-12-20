# encoding: utf-8
require 'spec_helper'

describe TradingItemBidRoundOfBidsHelper do
  describe '#destroy_last_bid_path' do
    let(:trading_item) { double(:trading_item, :id => 5) }
    let(:last_bid) { double(:last_bid, :to_param => "1") }

    it 'should returns the link to destroy' do
      trading_item.stub(:last_bid).and_return(last_bid)

      expect(helper.destroy_last_bid_path(trading_item)).to eq '/trading_item_bid_round_of_bids/1?trading_item_id=5'
    end
  end
end
