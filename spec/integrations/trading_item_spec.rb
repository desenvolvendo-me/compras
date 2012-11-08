require 'spec_helper'

describe TradingItem do
  describe '#bidders_available_for_current_round' do
    it 'should remove all disclassified bidders and all used for current round' do
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)
      nohup = Bidder.make!(:licitante_com_proposta_3)

      licitation_process = LicitationProcess.make!(:pregao_presencial,
        :bidders => [sobrinho, wenderson, nohup])

      trading = Trading.make!(:pregao_presencial,
        :trading_items => [subject],
        :licitation_process => licitation_process)

      trading_item = trading.trading_items.first

      bid_with_proposal = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => nohup.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid_without_proposal = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(subject.bidders_available_for_current_round).to eq [sobrinho]
    end
  end
end
