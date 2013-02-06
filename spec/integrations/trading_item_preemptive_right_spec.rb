require 'spec_helper'

describe TradingItemPreemptiveRight do
  subject do
    described_class.new(trading_item)
  end

  let(:bidder1) { Bidder.make!(:licitante) }
  let(:bidder2) { Bidder.make!(:licitante_sobrinho) }
  let(:bidder_benefited1) { Bidder.make!(:licitante_com_proposta_3) }
  let(:bidder_benefited2) { Bidder.make!(:me_pregao) }
  let(:trading_item) { trading.items.first }

  let(:licitation_process) do
    LicitationProcess.make!(:pregao_presencial,
      :bidders => [bidder1, bidder2, bidder_benefited1, bidder_benefited2])
  end

  let(:trading) do
    Trading.make!(:pregao_presencial, :licitation_process => licitation_process)
  end

  describe '#bidders_benefited' do
    context 'with benefited above 5%' do
      before do
        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder1.id,
          :amount => 1000.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder2.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited1.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited2.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder2.id,
          :amount => 90.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited1.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited2.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
      end

      it 'should be empty' do
        expect(subject.bidders_benefited).to eq []
      end
    end

    context 'with benefited below 5%' do
      before do
        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder1.id,
          :amount => 1000.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder2.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited1.id,
          :amount => 150.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited2.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :amount => 96.0,
          :bidder_id => bidder2.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited1.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited2.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
      end

      it 'should return all bidders benefited with preemptive right' do
        expect(subject.bidders_benefited).to eq [bidder_benefited2]
      end
    end
  end
end
