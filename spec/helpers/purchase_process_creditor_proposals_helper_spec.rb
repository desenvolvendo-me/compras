# encoding: utf-8
require 'spec_helper'

describe PurchaseProcessCreditorProposalsHelper do
  let(:licitation_process) { double(:licitation_process, to_s: 'Proc. Licitatório', id: 13) }
  let(:creditor)           { double(:creditor, to_s: 'Credor', id: 12) }

  describe '#title' do
    before { assign(:licitation_process, licitation_process) }

    it 'returns the index title' do
      expect(helper.title).to eq "Proposta Comercial Processo Proc. Licitatório"
    end
  end

  describe '#new_title' do
    it 'returns the new layout title' do
      expect(helper.new_title).to eq "Criar Proposta Comercial"
    end
  end

  describe '#edit_title' do
    it 'returns the edit layout title' do
      expect(helper.edit_title).to eq "Editar Proposta Comercial"
    end
  end

  describe '#subtitle' do
    before do
      assign(:creditor, creditor)
      helper.stub(licitation_process_object: licitation_process)
    end

    it 'returns the edit layout title' do
      expect(helper.subtitle).to eq "Fornecedor Credor - Processo Proc. Licitatório"
    end
  end

  describe '#form_partial' do
    before { helper.stub(licitation_process_object: licitation_process) }

    it 'returns the form based on licitation process judgment form kind' do
      licitation_process.stub(judgment_form_kind: :item)
      expect(helper.form_partial).to eq "form_item"

      licitation_process.stub(judgment_form_kind: :lot)
      expect(helper.form_partial).to eq "form_lot"
    end
  end

  describe '#update_path' do
    before { helper.stub(licitation_process_object: licitation_process) }

    it 'returns the path to update action on creditor proposals controller' do
      expect(helper.update_path).to eq "/purchase_process_creditor_proposals/13"
    end
  end

  describe '#creditor_proposals_collection' do
    let(:creditor_proposal) { double(:creditor_proposal, creditor_id: 1) }
    let(:resource) { double(:resource, creditor_proposals: [creditor_proposal]) }

    context 'when @proposals is set' do
      before { assign(:proposals, '@proposals') }

      it 'returns the @proposals when present' do
        expect(helper.creditor_proposals_collection).to eq "@proposals"
      end
    end

    context 'when @proposals is nil' do
      before do
        assign(:proposals, nil)
        assign(:creditor, creditor)
        helper.stub(resource: resource)
        creditor.stub(id: 1)
      end

      it 'returns the resource current creditor proposals' do
        expect(helper.creditor_proposals_collection).to eq [creditor_proposal]
      end
    end
  end

  describe '#view_or_edit_creditor_proposal' do
    before { assign(:licitation_process, licitation_process) }

    context 'when there are no creditor proposals' do
      before { licitation_process.stub(proposals_of_creditor: []) }

      it 'returns a link to new proposals' do
        expect(helper.view_or_edit_creditor_proposal(creditor)).to eq link_to 'Cadastrar propostas',
          new_purchase_process_creditor_proposal_path(licitation_process_id: 13, creditor_id: 12)
      end
    end

    context 'when there are creditor proposals' do
      before do
        licitation_process.stub(proposals_of_creditor: [double(:proposals)])
        licitation_process.stub(to_s: 13)
      end

      it 'returns a link to edit proposals' do
        expect(helper.view_or_edit_creditor_proposal(creditor)).to eq link_to 'Editar propostas',
          edit_purchase_process_creditor_proposal_path(id: 13, creditor_id: 12)
      end
    end
  end

  describe '#link_to_disqualify_creditor_proposal' do
    before { assign(:licitation_process, licitation_process) }

    context 'when there are no creditor proposals' do
      before { licitation_process.stub(proposals_of_creditor: []) }

      it 'returns a message with no proposal' do
        expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eq 'Nenhuma proposta cadastrada'
      end
    end

    context 'when there are creditor proposals' do
      before do
        licitation_process.stub(proposals_of_creditor: [double(:proposals)])
        licitation_process.stub(to_s: 13)
        helper.stub(disqualify_creditor_proposal_path: 'disqualify_path')
      end

      it 'returns a link to disqualify creditor proposal' do
        expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eq link_to 'Desclassificar propostas',
          'disqualify_path'
      end
    end
  end
end
