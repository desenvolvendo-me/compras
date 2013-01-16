# encoding: UTF-8
require 'spec_helper'

describe TradingItemBid do
  context 'at round_of_bids with 3 rounds' do
    let(:trading) { trading = Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.trading_items.first }
    let(:bidder) { trading.bidders.first }

    let :bid_with_proposal do
      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)
    end

    let :bid_without_proposal do
      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
    end

    let :bid_disqualified do
      TradingItemBid.create!(
        :round => 3,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::DISQUALIFIED,
        :disqualification_reason => 'Disqualified')
    end


    describe '.with_proposal' do
      it 'should show bids with proposals and ordered by amount' do
        expect(described_class.with_proposal).to eq [bid_with_proposal]
      end
    end

    describe '.with_no_proposal' do
      it 'should show bids with no proposals' do
        expect(described_class.with_no_proposal).to eq [bid_without_proposal, bid_disqualified]
      end
    end
  end

  describe '.for_trading_item' do
    it 'should returns bids of and trading item' do
      trading_item_with_proposal = TradingItem.make!(:item_pregao_presencial)
      trading_item_without_proposal = TradingItem.make!(:item_pregao_presencial, :minimum_reduction_value => 0.02)

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
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid2 = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_with_proposal.id,
        :bidder_id => bidder3.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)


      bid_another_item = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item_without_proposal.id,
        :bidder_id => bidder2.id,
        :amount => 0.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
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
        :round => 0,
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
        :round => 0,
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

  describe '.at_stage_of_negotiation' do
    it 'should returns bids at stage of negotiation' do
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
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      bid_disqualified = TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL,
        :disqualification_reason => 'Disqualified')

      expect(described_class.at_stage_of_negotiation).to eq [bid_disqualified]
    end
  end

  describe '.at_stage_of_negotiation' do
    it 'should returns bids at stage of negotiation' do
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
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      bid_disqualified = TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 80.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL,
        :disqualification_reason => 'Disqualified')

      expect(described_class.at_stage_of_negotiation).to eq [bid_disqualified]
    end
  end

  describe '.bids_by_bidder_and_item' do
    it 'should returns bids with proposal by bidder and item' do
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

      bid_with_proposal2 = TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      bid_without_proposal = TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        expect(described_class.bids_by_bidder_and_item(bidder.id, trading_item.id)).to include(bid_with_proposal, bid_with_proposal2)
        expect(described_class.bids_by_bidder_and_item(bidder.id, trading_item.id)).not_to include(bid_without_proposal)
    end
  end

  describe 'with many bids' do
    before do
      trading = Trading.make!(:pregao_presencial)

      trading_item = trading.trading_items.first
      first_bidder = trading.bidders.first
      second_bidder = trading.bidders.second

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => first_bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => second_bidder.id,
        :amount => 101.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => first_bidder.id,
        :amount => 99.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => second_bidder.id,
        :amount => 98.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => first_bidder.id,
        :amount => 97.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => second_bidder.id,
        :amount => 96.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => first_bidder.id,
        :amount => 95.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => second_bidder.id,
        :amount => 94.0,
        :stage => TradingItemBidStage::NEGOTIATION,
        :status => TradingItemBidStatus::WITH_PROPOSAL
      )
    end

    it 'should return lowest_proposal_by_item_at_stage_of_proposals' do
      expect(described_class.lowest_proposal_by_item_at_stage_of_proposals(1)).to eq BigDecimal("100.0")
    end

    it 'should return lowest_proposal_by_item_and_round' do
      expect(described_class.lowest_proposal_by_item_and_round(1, 1)).to eq BigDecimal("98.0")
    end

    it 'should return lowest_proposal_by_item_at_stage_of_negotiation' do
      expect(described_class.lowest_proposal_by_item_at_stage_of_negotiation(1)).to eq BigDecimal("94.0")
    end
  end

  describe '#last_valid_amount_by_bidder_and_item_and_round' do
    it 'should return the last valid amount by bidder and item and round' do
      TradingConfiguration.make!(:pregao)
      sobrinho = Bidder.make!(:licitante_sobrinho)
      wenderson = Bidder.make!(:licitante)

      licitation_process = LicitationProcess.make!(
        :pregao_presencial,
        :bidders => [sobrinho, wenderson]
      )

      trading_item = TradingItem.make!(:item_pregao_presencial)

      Trading.make!(
        :pregao_presencial,
        :trading_items => [trading_item],
        :licitation_process => licitation_process
      )

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => sobrinho.id,
        :amount => 100.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL,
        :stage => TradingItemBidStage::ROUND_OF_BIDS
      )

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => wenderson.id,
        :amount => 99.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL,
        :stage => TradingItemBidStage::ROUND_OF_BIDS
      )

      bid = TradingItemBid.first

      expect(bid.last_valid_amount_by_bidder_and_item_and_round).to eq 100.00
    end
  end
end
