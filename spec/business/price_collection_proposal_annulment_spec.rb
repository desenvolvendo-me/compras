require 'unit_helper'
require 'app/business/price_collection_proposal_annulment'

describe PriceCollectionProposalAnnulment do
  let :proposal do
    double('Proposal')
  end

  subject{ described_class.new(proposal) }

  it 'should not annul the proposal when annul is not present' do
    proposal.should_not_receive(:annul!)
    proposal.stub_chain(:annul, :present?).and_return false

    subject.change!
  end

  it 'should annul the proposal when annul is present' do
    proposal.should_receive(:annul!)
    proposal.stub_chain(:annul, :present?).and_return true

    subject.change!
  end
end
