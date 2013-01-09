require 'unit_helper'
require 'app/business/trading_item_bid_percent_calculator'
require 'active_support/core_ext/big_decimal/conversions'

describe TradingItemBidPercentCalculator do
  let(:bid_repository) { double(:bid_repository) }
  let(:bid) { double(:bid) }
  let(:trading_item_id) { double(:trading_item_bid) }

  context 'with bid is proposal and your amount is 120' do
    subject { described_class.new(bid, bid_repository) }

    before do
      bid.stub(:amount).and_return(120)
      bid.should_receive(:trading_item_id).at_least(1).times.and_return(trading_item_id)
      bid.stub(:proposals?).and_return(true)
    end

    it 'when lowest_proposal_by_item_at_stage_of_proposals is 0' do
      bid_repository.stub(:lowest_proposal_by_item_at_stage_of_proposals).
        with(trading_item_id).and_return(0.0)

      expect(subject.calculate!).to eq 0.0
    end

    it 'when lowest_proposal_by_item_at_stage_of_proposals is 100' do
      bid_repository.stub(:lowest_proposal_by_item_at_stage_of_proposals).
        with(trading_item_id).and_return(100.0)

      expect(subject.calculate!).to eq 20.0
    end
  end

  context 'with bid is round_of_bids and your amount is 120' do
    subject { described_class.new(bid, bid_repository) }

    before do
      bid.stub(:amount).and_return(120)
      bid.should_receive(:trading_item_id).at_least(1).times.and_return(trading_item_id)
      bid.stub(:proposals?).and_return(false)
      bid.stub(:round_of_bids?).and_return(true)
      bid.stub(:with_proposal?).and_return(true)
      bid.stub(:round).and_return(1)
    end

    it 'when lowest_proposal_by_item_and_round is 0' do
      bid_repository.stub(:lowest_proposal_by_item_and_round).
        with(trading_item_id, bid.round).and_return(0.0)

      expect(subject.calculate!).to eq 0.0
    end

    it 'when lowest_proposal_by_item_and_round is 100' do
      bid_repository.stub(:lowest_proposal_by_item_and_round).
        with(trading_item_id, bid.round).and_return(100.0)

      expect(subject.calculate!).to eq 20.0
    end
  end

  context 'with bid is round_of_bids and your amount is 120' do
    subject { described_class.new(bid, bid_repository) }

    before do
      bid.stub(:amount).and_return(120)
      bid.should_receive(:trading_item_id).at_least(1).times.and_return(trading_item_id)
      bid.stub(:proposals?).and_return(false)
      bid.stub(:round_of_bids?).and_return(false)
      bid.stub(:negotiation?).and_return(true)
      bid.stub(:with_proposal?).and_return(true)
      bid.stub(:round).and_return(1)
    end

    it 'when lowest_proposal_by_item_at_stage_of_negotiation is 0' do
      bid_repository.stub(:lowest_proposal_by_item_at_stage_of_negotiation).
        with(trading_item_id).and_return(0.0)

      expect(subject.calculate!).to eq 0.0
    end

    it 'when lowest_proposal_by_item_at_stage_of_negotiation is 100' do
      bid_repository.stub(:lowest_proposal_by_item_at_stage_of_negotiation).
        with(trading_item_id).and_return(100.0)

      expect(subject.calculate!).to eq 20.0
    end
  end
end
