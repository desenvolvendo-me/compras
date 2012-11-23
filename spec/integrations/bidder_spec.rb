# encoding: UTF-8
require 'spec_helper'

describe Bidder do
  context 'uniqueness validations' do
    before { LicitationProcess.make!(:processo_licitatorio_computador) }

    it { should validate_uniqueness_of(:creditor_id).scoped_to(:licitation_process_id) }
  end

  describe '.with_proposal_for_trading_item_round' do
    it 'should return all bidders with proposal for a specifc round' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :trading_items => [trading_item],
        :licitation_process => licitation_process)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(described_class.with_proposal_for_trading_item_round(1)).to eq [sobrinho]
    end

    it 'should return an empty array if round there are no bidder proposal' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :trading_items => [trading_item],
        :licitation_process => licitation_process)

      expect(described_class.with_proposal_for_trading_item_round(1)).to eq []
    end
  end

  describe '.with_proposal_for_proposal_stage_with_amount_lower_than_limit' do
    it 'should return only bidder with proposal lower than limit' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :trading_items => [trading_item],
        :licitation_process => licitation_process)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL,
        :stage => TradingItemBidStage::PROPOSALS)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 120.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL,
        :stage => TradingItemBidStage::PROPOSALS)

      expect(Bidder.with_proposal_for_proposal_stage_with_amount_lower_than_limit(110)).to eq [sobrinho]
    end
  end

  describe '.at_bid_round' do
    it 'should return only bidders for that specific round' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson])

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :trading_items => [trading_item],
        :licitation_process => licitation_process)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(described_class.at_bid_round(1)).to eq [sobrinho]
    end
  end

  describe '.with_proposal_for_trading_item' do
    it 'should return only bidders with proposal for a specific trading item' do
      trading_item_with_proposal = TradingItem.make!(:item_pregao_presencial)
      trading_item_without_proposal = TradingItem.make!(:item_pregao_presencial, :order => 2)

      trading = Trading.make!(:pregao_presencial,
        :trading_items => [trading_item_with_proposal,trading_item_without_proposal])

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_without_proposal.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder3.id,
        :amount => 0.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(described_class.with_proposal_for_trading_item(trading_item_with_proposal.id)).to eq [bidder1]
    end
  end

  describe '.at_trading_item_stage' do
    before do
      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson, nohup])

      trading = Trading.make!(:pregao_presencial,
        :trading_items =>[trading_item],
        :licitation_process => licitation_process
      )

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => nohup.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL)
    end

    let(:trading_item) { TradingItem.make!(:item_pregao_presencial) }
    let(:sobrinho) { Bidder.make!(:licitante_sobrinho) }
    let(:wenderson) { Bidder.make!(:licitante) }
    let(:nohup) { Bidder.make!(:licitante_com_proposta_3) }

    it 'should return only bidders for the stage of proposals of the trading item' do
      expect(described_class.at_trading_item_stage(trading_item.id, TradingItemBidStage::PROPOSALS)).to eq [sobrinho]
    end

    it 'should return only bidders for the stage of round_of_bids of the trading item' do
      expect(described_class.at_trading_item_stage(trading_item.id, TradingItemBidStage::ROUND_OF_BIDS)).to eq [wenderson]
    end

    it 'should return only bidders for the stage of negotiation of the trading item' do
      expect(described_class.at_trading_item_stage(trading_item.id, TradingItemBidStage::NEGOTIATION)).to eq [nohup]
    end
  end

  describe '#lower_trading_item_bid_amount' do
    it 'should return zero when bidder there is no proposal for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first
      bidder = trading.bidders.first

      expect(bidder.lower_trading_item_bid_amount(trading_item)).to eq 0
    end

    it 'should return the amount of lowest proposal of bidder for item' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 0.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 80.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(bidder1.lower_trading_item_bid_amount(trading_item)).to eq 80.0
    end

    it 'should return zero when bidder have no bid status with_proposal' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      bidder = trading.bidders.first

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 10.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(bidder.lower_trading_item_bid_amount(trading_item)).to eq 0.0
    end
  end
end
