require 'spec_helper'

describe TradingItemBidRoundCalculator do
  describe '#calculate' do
    subject { described_class.new(trading_item) }

    let(:trading_item) { TradingItem.make!(:item_pregao_presencial) }
    let(:sobrinho) { Bidder.make!(:licitante_sobrinho) }
    let(:wenderson) { Bidder.make!(:licitante) }
    let(:nohup) { Bidder.make!(:licitante_com_proposta_3) }

    before do
      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson, nohup])

      Trading.make!(
        :pregao_presencial,
        :trading_items => [trading_item],
        :licitation_process => licitation_process)
    end


    it 'should return 1 when there are no bids' do
      expect(described_class.new(trading_item).calculate).to eq 1
    end

    it 'should return 1 when left one biddder proposal for round 1' do
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

      expect(described_class.new(trading_item).calculate).to eq 1
    end

    it 'should return 2 all biddder have proposal for round 1' do
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

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => nohup.id,
        :amount => 80.0,
        :status => TradingItemBidStatus::DISQUALIFIED,
        :disqualification_reason => 'Disqualified')

      expect(described_class.new(trading_item).calculate).to eq 2
    end
  end
end
