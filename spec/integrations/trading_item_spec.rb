require 'spec_helper'

describe TradingItem do
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

      bid_disqualified = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 80.0,
        :status => TradingItemBidStatus::DISQUALIFIED)

      expect(subject.available_bidders).to eq [nohup]
    end
  end
end
