require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/trading_item_bid_stage_calculator'

describe TradingItemBidStageCalculator do
  subject do
    described_class.new(trading_item, :bidder_selector => bidder_selector)
  end

  let(:trading_item) { double(:trading_item) }
  let(:bidder_selector) { double(:bidder_selector) }

  context 'delegates' do
    it 'delegates trading_item_bids to trading_item' do
      trading_item.should_receive(:bids)

      subject.bids
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

    it 'delegates valid_bidder_for_negotiation? to trading_item' do
      trading_item.should_receive(:valid_bidder_for_negotiation?)

      subject.valid_bidder_for_negotiation?
    end
  end

  describe '#stage_of_proposals?' do
    it 'should be true when there are no bids' do
      subject.stub(:bids).and_return([])

      expect(subject).to be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to_not be_stage_of_round_of_bids
    end

    it 'should be on stage of proposals when there are bids but not all bidders give a positions about the bid' do
      bids = double(:trading_item_bid, :empty? => false,
                                 :at_stage_of_proposals => ['bid1', 'bid2'])
      bidders = double(:bidders, :enabled => ['bidder1', 'bidder2', 'bidder3'])

      subject.stub(:bids).and_return(bids)
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

      bids = double(:bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)


      subject.stub(:lowest_proposal_amount).and_return(10)
      subject.stub(:bids).and_return(bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      bidder_selector.should_receive(:selected).with(trading_item).
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
        :with_no_proposal => ['bidder1', 'bidder2'], :any? => true)

      bids = double(:bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(10)
      subject.stub(:bids).and_return(bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      bidder_selector.should_receive(:selected).with(trading_item).
              at_least(1).times.and_return(['bidder1', 'bidder2'])


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end

    it 'should be on stage of round of bids when there is only one bidder left at round of bids but it do not have a proposal' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => ['bidder1'], :any? => true)

      bids = double(:bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(nil)
      subject.stub(:bids).and_return(bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)
      bidder_selector.should_receive(:selected).with(trading_item).
              at_least(1).times.and_return(['bidder1', 'bidder2'])


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end

    it 'should be on stage of round of bids when there is no one bidder at round of bids' do
      at_stage_of_round_of_bids = double(:at_stage_of_round_of_bids,
        :with_no_proposal => [], :any? => false)

      bids = double(:bids, :empty? => false,
        :at_stage_of_round_of_bids => at_stage_of_round_of_bids)

      subject.stub(:lowest_proposal_amount).and_return(nil)
      subject.stub(:bids).and_return(bids)

      subject.should_receive(:all_bidders_have_proposal_for_proposals_stage?).
              at_least(1).times.and_return(true)


      expect(subject).to_not be_stage_of_proposals
      expect(subject).to_not be_stage_of_negotiation
      expect(subject).to be_stage_of_round_of_bids
    end
  end

  describe '#stage_of_proposal_report?' do
    context 'when on round_of_bids' do
      let(:bids) { double(:bids) }

      before do
        subject.stub(:stage_of_round_of_bids? => true)
        subject.stub(:bids => bids)
      end

      context 'when there is no bids at round_of_bids' do
        before do
          bids.stub(:at_stage_of_round_of_bids => [])
        end

        it { expect(subject).to be_stage_of_proposal_report }
      end

      context 'when there is bids at round_of_bids' do
        before do
          bids.stub(:at_stage_of_round_of_bids => ['bidder'])
        end

        it { expect(subject).to_not be_stage_of_proposal_report }
      end
    end

    context 'when not at round_of_bids' do
      before do
        subject.stub(:stage_of_round_of_bids? => false)
      end

      it { expect(subject).to_not be_stage_of_proposal_report }
    end
  end

  describe '#stage_of_classification?' do
    context 'when on negotiation' do
      let(:bids) { double(:trading_item_bids) }

      before do
        subject.stub(:stage_of_negotiation? => true)
        subject.stub(:bids => bids)
      end

      context 'when there is no bid at negotiation' do
        before do
          bids.stub(:negotiation => [])
        end

        it { expect(subject).to be_stage_of_classification }
      end

      context 'when there is bid at negotiation' do
        before do
          bids.stub(:negotiation => ['negotiations'])
        end

        context 'when there is a valid bidder for negotiation' do
          before do
            subject.stub(:valid_bidder_for_negotiation? => true)
          end

          it { expect(subject).to_not be_stage_of_classification }
        end

        context 'when there is no valid bidder for negotiation' do
          before do
            subject.stub(:valid_bidder_for_negotiation? => false)
          end

          it { expect(subject).to be_stage_of_classification }
        end
      end
    end

    context 'when on negotiation' do
      before do
        subject.stub(:stage_of_negotiation? => false)
      end

      it { expect(subject).to_not be_stage_of_classification }
    end
  end
end
