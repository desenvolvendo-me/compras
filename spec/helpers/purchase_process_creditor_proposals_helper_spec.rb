# encoding: utf-8
require 'spec_helper'

describe PurchaseProcessCreditorProposalsHelper do
  let(:creditor) { double(:creditor, to_s: 1, id: 1) }

  describe '#view_or_edit_creditor_proposal' do
    before { assign(:licitation_process, licitation_process) }

    context 'when creditor got proposals' do
      let(:licitation_process) { double(:licitation_process, to_s: 1, proposals_of_creditor: [creditor]) }

      it 'returns a link to edit proposals' do
        output = link_to 'Editar Propostas', batch_edit_purchase_process_creditor_proposals_path(creditor_id: creditor.id,
          licitation_process_id: licitation_process)

        expect(helper.view_or_edit_creditor_proposal(creditor)).to eql output
      end
    end

    context "when there's no creditor proposals" do
      let(:licitation_process) { double(:licitation_process, to_s: 1, proposals_of_creditor: []) }

      it 'returns a link to create new proposals' do
        output = link_to 'Cadastrar Propostas', new_purchase_process_creditor_proposal_path(creditor_id: creditor.id,
        licitation_process_id: licitation_process)

        expect(helper.view_or_edit_creditor_proposal(creditor)).to eql output
      end
    end
  end

  describe '#link_to_disqualify_creditor_proposal' do
    let(:disqualification) { double(:disqualification) }

    before { assign(:licitation_process, licitation_process) }

    context 'when creditor got proposals' do
      let(:licitation_process) { double(:licitation_process, to_s: 1, proposals_of_creditor: [creditor]) }

      context 'when a disqualification already exists' do
        before do
          disqualification.stub(:new_record?).and_return false
          disqualification.stub(:to_s).and_return '1'
          PurchaseProcessCreditorDisqualification.stub(:find_or_initialize).and_return disqualification
        end

        it 'returns a link to edit the proposal disqualification' do
          output = link_to 'Desclassificar Propostas', edit_purchase_process_creditor_disqualification_path(disqualification)

          expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eql output
        end
      end

      context "when there's no disclassification" do
        before do
          disqualification.stub(:new_record?).and_return true
          PurchaseProcessCreditorDisqualification.stub(:find_or_initialize).and_return disqualification
        end

        it 'returns a link to disqualify the proposals' do
          output = link_to 'Desclassificar Propostas', new_purchase_process_creditor_disqualification_path(creditor_id: creditor.id,
          licitation_process_id: licitation_process)

          expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eql output
        end
      end
    end

    context "when there's no creditor proposals" do
      let(:licitation_process) { double(:licitation_process, proposals_of_creditor: []) }

      it 'returns message about no proposals' do
        expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eql 'Nenhuma Proposta cadastrada'
      end
    end
  end

  describe '#collection_for_association' do
    let(:params) do
      { creditor_id: 1 }
    end

    context 'when creating a proposal and get an error' do
      let(:creditor_proposals) { double(:creditor_proposals, select: [creditor_proposal], where: []) }
      let(:creditor_proposal)  { double(:creditor_proposal, new_record: true) }

      it 'returns a dirty new proposal' do
        expect(helper.collection_for_association(creditor_proposals)).to eql creditor_proposal
      end
    end

    context 'when editing a proposal and get an error' do
      let(:creditor_proposals) { double(:creditor_proposals, select: [creditor_proposal], where: []) }
      let(:creditor_proposal)  { double(:creditor_proposal, id: 1) }

      it 'returns a dirty edited proposal' do
        expect(helper.collection_for_association(creditor_proposals)).to eql creditor_proposal
      end
    end

    context 'when acessing an existing proposal' do
      let(:creditor_proposals) { double(:creditor_proposals, select: [], where: [creditor_proposal]) }
      let(:creditor_proposal)  { double(:new_creditor_proposal) }

      it 'returns an existing proposal' do
        expect(helper.collection_for_association(creditor_proposals)).to eql creditor_proposal
      end
    end

    context 'when creating a new proposal' do
      let(:creditor_proposals) { double(:creditor_proposals, select: [], where: []) }
      let(:creditor_proposal)  { double(:new_creditor_proposal) }

      it 'returns a builded proposal' do
        creditor_proposals.should_receive(:build, with: { creditor_id: 1 }).and_return creditor_proposal
        expect(helper.collection_for_association(creditor_proposals)).to eql creditor_proposal
      end
    end
  end

  describe '#form_path' do
    context 'when batch editing' do
      it 'returns a url to update resource' do
        helper.stub(:params).and_return({ action: 'batch_edit' })
        expect(helper.form_path).to eq({ :url => batch_update_purchase_process_creditor_proposals_path, :method => :put })
      end
    end

    context 'when batch updating' do
      it 'returns a url to update resource' do
        helper.stub(:params).and_return({ action: 'batch_update' })
        expect(helper.form_path).to eq({ url: batch_update_purchase_process_creditor_proposals_path, method: :put })
      end
    end

    context 'when creating a new record' do
      it 'returns a url to create resource' do
        helper.stub(:params).and_return({ action: 'new' })
        expect(helper.form_path).to eq({ url: purchase_process_creditor_proposals_path, method: :post })
      end
    end
  end
end
