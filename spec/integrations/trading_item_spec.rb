require 'spec_helper'

describe TradingItem do
  describe '#bidders_available_for_current_round' do
    it 'should remove all disclassified bidders and all used for current round' do
      subject.stub(:minimum_reduction_value).and_return(0.01)

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

  describe '#finished_bid_stage?' do
    it 'should return false when there are more than one bidder with proposal' do
      trading = Trading.make!(:pregao_presencial)

      trading_item = trading.trading_items.first

      expect(trading_item.finished_bid_stage?).to be_false
    end

    it 'should return true when there is left only one bidder with proposal' do
      trading = Trading.make!(:pregao_presencial)

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      trading_item = trading.trading_items.first

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :disqualification_reason => 'Desistiu',
        :status => TradingItemBidStatus::DISQUALIFIED)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      expect(trading_item.finished_bid_stage?).to be_true
    end

    it 'should return false when there is only one bidder left and the round is not complete' do
      trading = Trading.make!(:pregao_presencial)

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      trading_item = trading.trading_items.first

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :disqualification_reason => 'Desistiu',
        :status => TradingItemBidStatus::DISQUALIFIED)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      expect(trading_item.finished_bid_stage?).to be_false
    end
  end
end
