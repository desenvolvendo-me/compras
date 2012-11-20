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

  describe '.with_no_proposal' do
    it 'should show bids with no proposals' do
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

      expect(described_class.with_no_proposal).to eq [bid_without_proposal, bid_disqualified]
    end
  end

  describe '.for_trading_item' do
    it 'should returns bids of and trading item' do
      trading_item_with_proposal = TradingItem.make!(:item_pregao_presencial)
      trading_item_without_proposal = TradingItem.make!(:item_pregao_presencial, :order => 2)

      trading = Trading.make!(:pregao_presencial,
        :trading_items => [trading_item_with_proposal,trading_item_without_proposal])

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      bid1 = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid2 = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder3.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)


      bid_another_item = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_without_proposal.id,
        :bidder_id => bidder2.id,
        :amount => 0.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(described_class.for_trading_item(trading_item_with_proposal)).to include(bid1, bid2)
      expect(described_class.for_trading_item(trading_item_with_proposal)).to_not include bid_another_item
    end
  end

  describe '.at_stage_of_proposals' do
    it 'should returns bids at stage of proposals' do
      trading = Trading.make!(:pregao_presencial)

      trading_item = trading.trading_items.first
      bidder = trading.bidders.first

      bid_with_proposal = TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid_without_proposal = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      bid_disqualified = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::DISQUALIFIED,
        :disqualification_reason => 'Disqualified')

      expect(described_class.at_stage_of_proposals).to eq [bid_with_proposal, bid_without_proposal]
    end
  end

  describe '.at_stage_of_round_of_bids' do
    it 'should returns bids at stage of proposals' do
      trading = Trading.make!(:pregao_presencial)

      trading_item = trading.trading_items.first
      bidder = trading.bidders.first

      bid_with_proposal = TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid_without_proposal = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      bid_disqualified = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::DISQUALIFIED,
        :disqualification_reason => 'Disqualified')

      expect(described_class.at_stage_of_round_of_bids).to eq [bid_disqualified]
    end
  end
end
