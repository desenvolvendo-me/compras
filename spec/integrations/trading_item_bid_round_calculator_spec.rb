require 'spec_helper'

describe TradingItemBidRoundCalculator do
  describe '#calculate' do
    subject { described_class.new(trading_item) }

    let(:licitation_process) do
      LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson, nohup])
    end

    let(:trading) do
      Trading.make!(
        :pregao_presencial,
        :licitation_process => licitation_process)
    end

    let(:trading_item) { trading.items.first }
    let(:sobrinho) { Bidder.make!(:licitante_sobrinho) }
    let(:wenderson) { Bidder.make!(:licitante) }
    let(:nohup) { Bidder.make!(:licitante_com_proposta_3) }

    context 'at stage of round of bidders' do
      before do

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => sobrinho.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => wenderson.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => nohup.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)
      end

      it 'should return 1 when there are no bids but it is on stage of round of bids' do
        expect(subject.calculate).to eq 1
      end

      it 'should return 1 when left one biddder proposal for round 1' do
        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => sobrinho.id,
          :amount => 99.99,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => wenderson.id,
          :amount => 90.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        expect(subject.calculate).to eq 1
      end

      it 'should return 2 all biddder have proposal for round 1' do
        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => sobrinho.id,
          :amount => 99.99,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => wenderson.id,
          :amount => 90.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => nohup.id,
          :amount => 80.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::DISQUALIFIED,
          :disqualification_reason => 'Disqualified')

        expect(subject.calculate).to eq 2
      end

      it 'should calculate the current round' do
        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => nohup.id,
          :amount => 99.99,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        expect(subject.calculate).to eq 1

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => wenderson.id,
          :amount => 99.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        expect(subject.calculate).to eq 1

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => sobrinho.id,
          :amount => 98.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        expect(subject.calculate).to eq 2

        TradingItemBid.create!(
          :round => 2,
          :trading_item_id => trading_item.id,
          :bidder_id => nohup.id,
          :amount => 0.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        expect(subject.calculate).to eq 2

        TradingItemBid.create!(
          :round => 2,
          :trading_item_id => trading_item.id,
          :bidder_id => wenderson.id,
          :amount => 97.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        expect(subject.calculate).to eq 2

        TradingItemBid.create!(
          :round => 2,
          :trading_item_id => trading_item.id,
          :bidder_id => sobrinho.id,
          :amount => 96.0,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        expect(subject.calculate).to eq 3
      end
    end
  end
end
