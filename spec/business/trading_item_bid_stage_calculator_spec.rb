require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/trading_item_bid_stage_calculator'

describe TradingItemBidStageCalculator do
  subject do
    described_class.new(trading_item, trading_item_bidders)
  end

  let(:trading_item) { double(:trading_item) }
  let(:trading_item_bidders) { double(:trading_item_bidders) }

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

    it 'delegates selected_bidders_at_proposals to trading_item' do
      trading_item.should_receive(:selected_bidders_at_proposals)

      subject.selected_bidders_at_proposals
    end
  end

  describe '#stage_of_proposals?' do
    it 'should be true when there are no bids' do
      subject.stub(:trading_item_bids).and_return([])

      expect(subject).to be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to_not be_stage_of_round_of_bids
    end

    it 'should be on stage of proposals when there are bids but not all bidders give a positions about the bid' do
      trading_item_bids = double(:trading_item_bid, :empty? => false,
                                 :at_stage_of_proposals => ['bid1', 'bid2'])
      bidders = double(:bidders, :enabled => ['bidder1', 'bidder2', 'bidder3'])

      subject.stub(:trading_item_bids).and_return(trading_item_bids)
      subject.stub(:bidders).and_return(bidders)

      expect(subject).to be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to_not be_stage_of_round_of_bids
    end
  end

  describe '#stage_of_negotiation?' do
    it 'should be on stage of negotiation when only one bid left with proposal' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => ['bidder1'], :any? => true)

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)


      subject.stub(:lowest_proposal_amount).and_return(10)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      trading_item_bidders.should_receive(:selected_for_trading_item_size).
              at_least(1).times.and_return(2)


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to be_stage_of_negotiation
      expect(subject).to_not be_stage_of_round_of_bids
    end
  end

  describe '#stage_of_round_of_bids?' do
    it 'should be on stage of round of bids when is not on stage of proposal neither stage of negotiation' do
      subject.stub(:stage_of_proposals?).and_return(false)
      subject.stub(:stage_of_negotiation?).and_return(false)

      expect(subject).to be_stage_of_round_of_bids
    end

    it 'should be on stage of round of bids when there are more than 1 bidder available' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => ['bidder1', 'bidder2'], :any? => true)

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(10)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      trading_item_bidders.should_receive(:selected_for_trading_item_size).
              at_least(1).times.and_return(2)


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end

    it 'should be on stage of round of bids when there is only one bidder left at round of bids but it do not have a proposal' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => ['bidder1'], :any? => true)

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(nil)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      trading_item_bidders.should_receive(:selected_for_trading_item_size).
              at_least(1).times.and_return(2)


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end

    it 'should be on stage of round of bids when there is no one bidder at round of bids' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => [], :any? => false)

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(nil)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end
  end

  describe '#show_proposal_report' do
    it 'should return true when stage_of_rounds_of_bids is true and dont have bids for stage of round' do
      subject.stub(:stage_of_round_of_bids?).and_return(true)
      trading_item_bids = double(:trading_item_bids)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      trading_item_bids.should_receive(:at_stage_of_round_of_bids).and_return(trading_item_bids)
      trading_item_bids.stub(:empty?).and_return(true)

      expect(subject.show_proposal_report?).to eq true
    end

    it 'should return false when stage_of_rounds_of_bids is false' do
      subject.stub(:stage_of_round_of_bids?).and_return(false)

      expect(subject.show_proposal_report?).to eq false
    end

    it 'should return false when stage_of_rounds_of_bids is true and have bids for stage of round' do
      subject.stub(:stage_of_round_of_bids?).and_return(true)
      trading_item_bids = double(:trading_item_bids)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      trading_item_bids.should_receive(:at_stage_of_round_of_bids).and_return(trading_item_bids)
      trading_item_bids.stub(:empty?).and_return(false)

      expect(subject.show_proposal_report?).to eq false
    end
  end
end
