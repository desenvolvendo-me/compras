require 'unit_helper'
require 'app/business/purchase_process_creditor_proposal_ranking'

describe PurchaseProcessCreditorProposalRanking do
  let(:creditor_proposal) { double :creditor_proposal }
  let(:proposals)         { double :proposals }
  let(:repository)        { double :repository }
  let(:subject)           { described_class.new(creditor_proposal, repository) }

  before { repository.stub(:find_brothers_for_ranking).and_return proposals }

  describe '.rank!' do
    it 'initializes and call set_ranking' do
      subject.class.should_receive(:new).with(creditor_proposal).and_return subject
      subject.should_receive :set_ranking

      subject.class.rank! creditor_proposal
    end
  end

  describe '#set_ranking' do
    let(:proposals) { [double(:proposal)] }

    before { subject.stub(:each_ordered_proposals).and_yield proposals }

    it 'sets the ranking for each proposal' do
      subject.should_receive(:rank_proposals).with(proposals, 1)
      subject.should_receive :reset_proposals
      subject.set_ranking
    end
  end

  describe '#rank_proposals' do
    let(:proposal) { double :proposal }

    context 'when theres only one proposal' do
      let(:proposals) { [proposal] }

      it 'ranks the proposal with the passed rank' do
        proposal.should_receive(:apply_ranking!).with 1

        subject.send(:rank_proposals, proposals, 1)
      end
    end

    context 'when theres tied proposals' do
      let(:proposals) { [proposal, proposal] }

      it 'draws the proposals' do
        subject.should_receive(:tie_proposals).with proposals

        subject.send(:rank_proposals, proposals, 1)
      end
    end
  end

  describe '#tie_proposals' do
    let(:proposal_1) { double :proposal_1 }
    let(:proposal_2) { double :proposal_2 }
    let(:proposals)  { [proposal_1, proposal_2] }

    it 'updates each proposal with ranking 0' do
      proposal_1.should_receive(:tie_ranking!)
      proposal_2.should_receive(:tie_ranking!)

      subject.send(:tie_proposals, proposals)
    end
  end

  describe '#reset_proposals' do
    let(:proposal_1) { double :proposal_1 }
    let(:proposal_2) { double :proposal_2 }
    let(:proposals)  { [proposal_1, proposal_2] }

    before do
      repository.should_receive(:find_brothers).with(proposal_1).and_return proposals
      subject.stub(:creditor_proposal).and_return proposal_1
    end

    it 'resets each proposals ranking' do
      proposal_1.should_receive(:reset_ranking!)
      proposal_2.should_receive(:reset_ranking!)

      subject.send(:reset_proposals)
    end
  end
end
