# encoding: UTF-8
require 'spec_helper'

describe TradingItemBid do
  describe '.with_proposal' do
    it 'should show bids with proposals and ordered by amount' do
      trading = Trading.make!(:pregao_presencial)

      trading_item = trading.trading_items.first
      bidder = trading.bidders.first

      bid_with_proposal = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid_without_proposal = TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      bid_disqualified = TradingItemBid.create!(
        :round => 3,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :status => TradingItemBidStatus::DISQUALIFIED,
        :disqualification_reason => 'Disqualified')

      expect(described_class.with_proposal).to eq [bid_with_proposal]
    end
  end
end
