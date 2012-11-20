require 'unit_helper'
require 'enumerate_it'
require 'active_support/core_ext/module/delegation'
require 'app/enumerations/trading_item_bid_stage'
require 'app/business/trading_item_bid_stage_calculator'

describe TradingItemBidStageCalculator do
  subject do
    described_class.new(trading_item)
  end

  let(:trading_item) { double(:trading_item) }

  context 'delegates' do
    it 'delegates trading_item_bids to trading_item' do
      trading_item.should_receive(:trading_item_bids)

      subject.trading_item_bids
    end

    it 'delegates bidder to trading_item' do
      trading_item.should_receive(:bidders)

      subject.bidders
    end

    it 'delegates bidder to trading_item' do
      trading_item.should_receive(:lowest_proposal_amount)

      subject.lowest_proposal_amount
    end
  end

  describe '#current_round' do
    it 'returns \'proposals\' when it is on stage of proposals' do
      subject.stub(:is_on_stage_of_proposal?).and_return(true)

      expect(subject.current_stage).to eq TradingItemBidStage::PROPOSALS
    end

    it 'returns \'proposals\' stage when there are no bids' do
      subject.stub(:trading_item_bids).and_return([])

      expect(subject.current_stage).to eq TradingItemBidStage::PROPOSALS
    end

    it 'returns \'proposals\' stage when there are bids but not all bidders give a positions about the bid' do
      trading_item_bids = double(:trading_item_bid, :empty? => false,
                                 :at_stage_of_proposals => ['bid1', 'bid2'])

      subject.stub(:trading_item_bids).and_return(trading_item_bids)
      subject.stub(:bidders).and_return(['bidder1', 'bidder2', 'bidder3'])

      expect(subject.current_stage).to eq TradingItemBidStage::PROPOSALS
    end

    it 'returns \'negotiation\' when it is not on stage of proposals and is on negotiation stage' do
      subject.stub(:is_on_stage_of_proposal?).and_return(false)
      subject.stub(:is_on_stage_of_negotiation?).and_return(true)

      expect(subject.current_stage).to eq TradingItemBidStage::NEGOTIATION
    end

    it 'returns \'negotiation\' when left only one bid with proposal' do
      subject.stub(:is_on_stage_of_proposal?).and_return(false)
      subject.stub(:left_only_one_bidder_at_round_of_bids?).and_return(true)
      subject.stub(:lowest_proposal_amount).and_return(10)

      expect(subject.current_stage).to eq TradingItemBidStage::NEGOTIATION
    end

    it 'returns \'round_of_bids\' when is not on stage of proposal neither stage of negotiation' do
      subject.stub(:is_on_stage_of_proposal?).and_return(false)
      subject.stub(:is_on_stage_of_negotiation?).and_return(false)

      expect(subject.current_stage).to eq TradingItemBidStage::ROUND_OF_BIDS
    end
  end
end
