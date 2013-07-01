require 'unit_helper'
require 'app/business/purchase_process_creditor_proposal_builder'

describe PurchaseProcessCreditorProposalBuilder do
  let(:licitation_process) { double :licitation_process, judgment_form_kind: :item }
  let(:creditor)           { double :creditor }

  subject do
    described_class.new(licitation_process, creditor)
  end

  describe '.build_proposals' do
    let(:instance) { double :instance }

    it 'creates an object and return its proposals' do
      subject.class.should_receive(:new).with(licitation_process, creditor).and_return instance
      instance.should_receive :proposals

      subject.class.build_proposals(licitation_process, creditor)
    end
  end

  describe '#proposals' do
    let(:proposal_1) { double(:proposal, name: 'Proposta 1') }
    let(:proposal_2) { double(:proposal, name: 'Proposta 2') }

    it 'returns all builded proposals' do
      subject.should_receive(:each_object).and_yield(proposal_1).and_yield(proposal_2)
      subject.should_receive(:build_creditor_proposal).with(proposal_1).and_return proposal_1
      subject.should_receive(:build_creditor_proposal).with(proposal_2).and_return proposal_2

      expect(subject.proposals).to eq [proposal_1, proposal_2]
    end
  end
end
