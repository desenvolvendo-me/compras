# encoding: utf-8
require 'spec_helper'

describe PurchaseProcessCreditorProposalsHelper do
  let(:creditor)                { double(:creditor, to_s: 1, id: 1) }
  let(:proposal_path_generator) { double :proposal_path_generator }

  before { assign(:proposal_path_generator, proposal_path_generator) }

  describe '#view_or_edit_creditor_proposal' do
    before do
      assign(:licitation_process, licitation_process)
    end

    context 'when creditor got proposals' do
      let(:licitation_process) { double(:licitation_process, to_s: 1, proposals_of_creditor: [creditor]) }

      it 'returns a link to edit proposals via the path generator' do
        proposal_path_generator.stub(:edit_proposal_path).and_return 'edit_proposal_path'
        expect(helper.view_or_edit_creditor_proposal(creditor)).to eql link_to('Editar propostas', 'edit_proposal_path')
      end
    end

    context "when there's no creditor proposals via the path generator" do
      let(:licitation_process) { double(:licitation_process, to_s: 1, proposals_of_creditor: []) }

      it 'returns a link to create new proposals' do
        proposal_path_generator.stub(:new_proposal_path).and_return 'new_proposal_path'

        expect(helper.view_or_edit_creditor_proposal(creditor)).to eql link_to('Cadastrar propostas', 'new_proposal_path')
      end
    end
  end

  describe '#link_to_disqualify_creditor_proposal' do
    let(:disqualification) { double(:disqualification) }

    before { assign(:licitation_process, licitation_process) }

    context 'when creditor got proposals' do
      let(:licitation_process) { double(:licitation_process, to_s: 1, proposals_of_creditor: [creditor]) }

      it 'returns a link to edit the proposal disqualification via the proposal path generator' do
        proposal_path_generator.stub(:disqualify_proposal_path).and_return 'disqualify_proposal_path'

        expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eql link_to('Desclassificar propostas', 'disqualify_proposal_path')
      end
    end

    context "when there's no creditor proposals" do
      let(:licitation_process) { double(:licitation_process, proposals_of_creditor: []) }

      it 'returns message about no proposals' do
        expect(helper.link_to_disqualify_creditor_proposal(creditor)).to eql 'Nenhuma proposta cadastrada'
      end
    end
  end

  describe '#creditors_proposals_url' do
    it 'returns the creditors proposals path via the path generator' do
      proposal_path_generator.should_receive(:proposals_path).and_return 'proposals_path'
      expect(helper.creditors_proposals_url).to eql 'proposals_path'
    end
  end

  describe '#form_path' do
    it 'returns a form path via the path generator' do
      helper.stub(:params).and_return({ action: 'new' })
      proposal_path_generator.should_receive(:form_proposal_path).with 'new'
      helper.form_path
    end
  end

  describe '#disqualification_status_message' do
    let(:licitation_process) { double(:licitation_process, id: 1) }

    before do
      assign(:licitation_process, licitation_process)
      helper.stub(:disqualification_status).and_return :fully
    end

    it 'returns the translated disqualification status' do
      helper.disqualification_status_message(creditor).should eql "Totalmente"
    end
  end

  describe '#disqualification_status' do
    let(:licitation_process) { double(:licitation_process, id: 1) }

    before do
      assign(:licitation_process, licitation_process)
    end

    it 'returns the disqualification status' do
      PurchaseProcessCreditorDisqualification.should_receive(:disqualification_status).with(1, 1).and_return :fully
      expect(helper.send(:disqualification_status, creditor)).to eql :fully
    end
  end
end
