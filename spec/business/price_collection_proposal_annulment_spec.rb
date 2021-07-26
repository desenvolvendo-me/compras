require 'unit_helper'
require 'app/business/price_collection_proposal_annulment'

describe PriceCollectionProposalAnnulment do
  let :proposal do
    double('Proposal')
  end

  subject{ described_class.new(proposal) }

  describe '#change!' do
    it 'should not annul the proposal when annul is already present' do
      proposal.should_not_receive(:annul!)
      proposal.stub_chain(:annul, :present?).and_return true

      subject.change!
    end

    it 'should annul the proposal when annul is not present' do
      proposal.should_receive(:annul!)
      proposal.stub_chain(:annul, :present?).and_return false

      subject.change!
    end
  end

  describe '#create_annul!' do
    let :annul do
      double('Annul', :employee_id => 1, :date => 'current date', :description => 'foo bar')
    end

    it 'builds the annul on the current proposal, and save' do
      proposal.should_receive(:build_annul).with(:employee_id => 1, :date => 'current date', :description => 'foo bar').and_return double(:save => true)

      expect(subject.create_annul!(annul)).to eq true
    end
  end

  describe 'PriceCollectionProposalAnnulment.annul_proposals!' do
    let :proposals do
      [proposal]
    end

    let :annul do
      double('Annul')
    end

    it 'should annul all the proposals' do
      PriceCollectionProposalAnnulment.any_instance.should_receive(:create_annul!).with(annul).and_return true
      PriceCollectionProposalAnnulment.any_instance.should_receive(:change!)

      described_class.annul_proposals!(proposals, annul)
    end
  end
end
