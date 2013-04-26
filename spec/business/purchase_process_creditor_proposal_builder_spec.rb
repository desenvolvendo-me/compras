require 'unit_helper'
require 'app/business/purchase_process_creditor_proposal_builder'

describe PurchaseProcessCreditorProposalBuilder do
  let(:subject)          { PurchaseProcessCreditorProposalBuilder }
  let(:proposals)        { double :proposals }
  let(:creditor)         { double :creditor, to_i: 1 }
  let(:purchase_process) { double :purchase_process, id: 1 }

  describe '.item_proposals' do
    it 'generates the item proposals for the form' do
      subject.should_receive(:build_or_find).with(proposals, { creditor_id: 1 })
      subject.item_proposals(proposals, creditor)
    end
  end

  describe '.lot_proposals' do
    let(:lot) { double :lot }

    before do
      purchase_process.stub(:creditor_proposals).and_return []
      purchase_process.stub(:each_item_lot).and_yield(lot)
    end

    it 'generates the lot proposals for the form' do
      attrs = { licitation_process_id: 1, creditor_id: 1, lot: lot }
      subject.should_receive(:build_or_find).with(purchase_process.creditor_proposals, attrs)
      subject.lot_proposals(purchase_process, creditor)
    end
  end

  describe '.check_attrs' do
    let(:proposal) { double :proposal }

    context 'when proposal got all the passed attributes' do
      before do
        proposal.stub(:[]).with(:value).and_return 1
      end

      it 'returns true' do
        expect(subject.check_attrs(proposal, { value: 1 })).to be_true
      end
    end

    context 'when proposal doesnt match the passed attributes' do
      before do
        proposal.stub(:[]).with(:value).and_return 2
      end

      it 'returns false' do
        expect(subject.check_attrs(proposal, { value: 1 })).to be_false
      end
    end
  end

  describe '.build_or_find' do
    context 'when creating a proposal and get an error' do
      let(:proposal)  { double(:proposal, new_record?: true) }
      let(:proposals) { [proposal] }

      it 'returns the proposal object' do
        proposal.should_receive(:new_record?).and_return true
        subject.should_receive(:check_attrs).with(proposal, {}).and_return true

        expect(subject.build_or_find(proposals, {})).to eql proposal
      end
    end

    context 'when editing a proposal and get an error' do
      let(:proposal)  { double(:proposal, new_record?: false) }
      let(:proposals) { [proposal] }

      it 'returns the proposal object' do
        subject.should_receive(:check_attrs).with(proposal, {}).and_return true

        expect(subject.build_or_find(proposals, {})).to eql proposal
      end
    end

    context 'when acessing an existing proposal' do
      let(:proposal)  { double(:proposal, new_record?: false) }
      let(:proposals) { [proposal] }

      it 'returns the proposal object' do
        subject.should_receive(:check_attrs).with(proposal, {}).and_return false
        proposals.should_receive(:where).with({}).and_return ['proposal']

        expect(subject.build_or_find(proposals, {})).to eql 'proposal'
      end
    end

    context 'when creating a new proposal' do
      let(:proposal)  { double(:proposal, new_record?: false) }
      let(:proposals) { [] }

      it 'returns the proposal object' do
        proposals.should_receive(:where).with({}).and_return []
        proposals.should_receive(:build).with({}).and_return 'new_proposal'

        expect(subject.build_or_find(proposals, {})).to eql 'new_proposal'
      end
    end
  end
end
