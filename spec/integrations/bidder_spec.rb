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
end
