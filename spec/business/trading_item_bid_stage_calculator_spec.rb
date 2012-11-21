require 'unit_helper'
require 'active_support/core_ext/module/delegation'
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

      subject.stub(:trading_item_bids).and_return(trading_item_bids)
      subject.stub(:bidders).and_return(['bidder1', 'bidder2', 'bidder3'])

      expect(subject).to be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to_not be_stage_of_round_of_bids
    end
  end

  describe '#stage_of_negotiation?' do
    it 'should be on stage of negotiation when only one bid left with proposal' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => ['bidder1'])

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(10)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      subject.should_receive(:selected_bidders_at_proposals).
              at_least(1).times.and_return(['bidder1', 'bidder2'])


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
        :with_no_proposal => ['bidder1', 'bidder2'])

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(10)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      subject.should_receive(:selected_bidders_at_proposals).
              at_least(1).times.and_return(['bidder1', 'bidder2'])


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end

    it 'should be on stage of round of bids when there is only one bidder left at round of bids but it do not have a proposal' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => ['bidder1'])

      trading_item_bids = double(:trading_item_bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(nil)
      subject.stub(:trading_item_bids).and_return(trading_item_bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      subject.should_receive(:selected_bidders_at_proposals).
              at_least(1).times.and_return(['bidder1', 'bidder2'])


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end
  end
end
