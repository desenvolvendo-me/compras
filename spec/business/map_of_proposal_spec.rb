require 'unit_helper'
require 'app/business/map_of_proposal'

describe MapOfProposal do
  let(:purchase_process) { double('LicitationProcess', id: 1) }

  let :bidder_one do
    double('Bidder', id: 11, benefited: false, status: :enabled)
  end

  let :bidder_two do
    double('Bidder', id: 12, benefited: true, status: :enabled)
  end

  let :proposal_one do
    double('PurchaseProcessCreditorProposal', item_id: 1, unit_price: 5.99,
      creditor: bidder_one, creditor_benefited: false)
  end

  let :proposal_two do
    double('PurchaseProcessCreditorProposal', item_id: 1, unit_price: 4.99,
      creditor: bidder_two, creditor_benefited: true)
  end

  let :repository do
    double(:repository)
  end

  describe '#lowest_proposal?' do
    let(:proposals_with_lowest_unit_price) { [proposal_two] }

    context 'when has proposal in proposals with lowest unit price' do
      subject { described_class.new(proposal_two, repository) }

      it 'should be true' do
        repository.should_receive(:where).
                   at_least(1).times.
                   and_return(proposals_with_lowest_unit_price)

        expect(subject.lowest_proposal?).to be_true
      end
    end

    context 'when has not proposal in proposals with lowest unit price' do
      subject { described_class.new(proposal_one, repository) }

      it 'should be false' do
        repository.should_receive(:where).
                   at_least(1).times.
                   and_return(proposals_with_lowest_unit_price)

        expect(subject.lowest_proposal?).to be_false
      end
    end
  end

  describe '#draw?' do
    let(:proposals) { [proposal_two, proposal_one] }

    context 'when creditor is benefited and value lowest proposal with margin is most equal to proposal unit_price' do
      let(:value_lowest_proposal_with_margin) { 5.30 }

      subject { described_class.new(proposal_two, repository) }

      it 'should be true' do
        repository.should_receive(:where).
                   at_least(1).times.
                   and_return(proposals)
        proposals.stub(:order).and_return(proposals)

        expect(subject.draw?).to be_true
      end
    end

    context 'when creditor is not benefited and value lowest proposal with margin is greater than to proposal unit_price' do
      let(:value_lowest_proposal) { 4.99 }

      subject { described_class.new(proposal_one, repository) }

      it 'should be false' do
        repository.should_receive(:where).
                   at_least(1).times.
                   and_return(proposals)
        proposals.stub(:order).and_return(proposals)

        expect(subject.draw?).to be_false
      end
    end
  end
end
