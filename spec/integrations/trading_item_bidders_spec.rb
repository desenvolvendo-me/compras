require 'spec_helper'

describe TradingItemBidders do
  describe '#bidders_ordered_by_amount' do
    subject do
      described_class.new(trading_item, trading_item.bidders)
    end

    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    before do
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      # bidder not selected due to too high value
      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder2.id,
        :trading_item_id => trading_item.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => trading_item.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder3.id,
        :trading_item_id => trading_item.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      BidderDisqualification.create!(:bidder_id => bidder1.id, :reason => 'inabilitado')
    end

    it 'should order bidders by amount for trading_item' do
      expect(subject.bidders_ordered_by_amount).to eq [bidder1, bidder3, bidder2]
    end
  end
end
