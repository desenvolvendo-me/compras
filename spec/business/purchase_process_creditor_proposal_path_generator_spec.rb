require 'unit_helper'
require 'app/business/purchase_process_creditor_proposal_path_generator'

describe PurchaseProcessCreditorProposalPathGenerator do
  let(:judgment_form)    { double(:judgment_form, kind: :kind) }
  let(:controller)       { double(:controller) }
  let(:purchase_process) { double(:purchase_process, to_s: '1', judgment_form: judgment_form) }
  let(:creditor)         { double(:creditor, to_s: '1') }
  let(:params)           { { licitation_process_id: purchase_process, creditor_id: creditor } }

  let :subject do
    params = { purchase_process: purchase_process, creditor: creditor }
    PurchaseProcessCreditorProposalPathGenerator.new(purchase_process, controller)
  end

  describe '#proposals_path' do
    let(:params) { { licitation_process_id: purchase_process } }

    context 'licitation process is judged by item' do
      before { judgment_form.stub(:kind).and_return 'item' }

      it 'returns the creditors proposals item path' do
        controller.should_receive(:creditors_purchase_process_item_creditor_proposals_path).with params
        subject.proposals_path
      end
    end

    context 'licitation process is judged by lot' do
      before { judgment_form.stub(:kind).and_return 'lot' }

      it 'returns the creditors proposals lot path' do
        controller.should_receive(:creditors_purchase_process_lot_creditor_proposals_path).with params
        subject.proposals_path
      end
    end

    context 'licitation process is global judged' do
      before { judgment_form.stub(:kind).and_return 'global' }

      it 'returns the creditors proposals global path' do
        controller.should_receive(:creditors_purchase_process_global_creditor_proposals_path).with params
        subject.proposals_path
      end
    end
  end

  describe '#new_proposal_path' do
    context 'licitation process is judged by item' do
      before { judgment_form.stub(:kind).and_return 'item' }

      it 'returns the new item proposal path' do
        controller.should_receive(:new_purchase_process_item_creditor_proposal_path).with params
        subject.new_proposal_path creditor
      end
    end

    context 'licitation process is judged by lot' do
      before { judgment_form.stub(:kind).and_return 'lot' }

      it 'returns the new lot proposal path' do
        controller.should_receive(:new_purchase_process_lot_creditor_proposal_path).with params
        subject.new_proposal_path creditor
      end
    end

    context 'licitation process is global judged' do
      before { judgment_form.stub(:kind).and_return 'global' }

      it 'returns the new global proposal path' do
        controller.should_receive(:new_purchase_process_global_creditor_proposal_path).with params
        subject.new_proposal_path creditor
      end
    end
  end

  describe '#edit_proposal_path' do
    context 'licitation process is judged by item' do
      before { judgment_form.stub(:kind).and_return 'item' }

      it 'returns the edit item proposal path' do
        controller.should_receive(:batch_edit_purchase_process_item_creditor_proposals_path).with params
        subject.edit_proposal_path creditor
      end
    end

    context 'licitation process is judged by lot' do
      before { judgment_form.stub(:kind).and_return 'lot' }

      it 'returns the edit lot proposal path' do
        controller.should_receive(:batch_edit_purchase_process_lot_creditor_proposals_path).with params
        subject.edit_proposal_path creditor
      end
    end

    context 'licitation process is global judged' do
      before { judgment_form.stub(:kind).and_return 'global' }

      it 'returns the edit global proposal path' do
        controller.should_receive(:batch_edit_purchase_process_global_creditor_proposals_path).with params
        subject.edit_proposal_path creditor
      end
    end
  end

  describe '#disqualify_proposal_path' do
    let(:disqualification) { double(:disqualification) }

    before { subject.stub(:disqualification).and_return disqualification }

    context 'when a disqualification exists' do
      before { disqualification.stub(:new_record?).and_return false }

      it 'returns a link to edit the proposal disqualification' do
        controller.should_receive(:edit_purchase_process_creditor_disqualification_path).with disqualification
        subject.disqualify_proposal_path creditor
      end
    end

    context 'when there is no disqualification' do
      before { disqualification.stub(:new_record?).and_return true }

      it 'returns a link to new proposal disqualification' do
        controller.should_receive(:new_purchase_process_creditor_disqualification_path).with params
        subject.disqualify_proposal_path creditor
      end
    end
  end

  describe '#form_proposal_path' do
    context 'when creating a new proposal' do
      it 'returns form url to create path' do
        subject.stub(:create_params).and_return 'create_params'
        expect(subject.form_proposal_path('new')).to eql 'create_params'
      end
    end

    context 'when editing a proposal' do
      it 'returns form url to batch update path' do
        subject.stub(:batch_update_params).and_return 'batch_update_params'
        expect(subject.form_proposal_path('batch_update')).to eql 'batch_update_params'
      end
    end
  end

  describe '#create_params' do
    before do
      judgment_form.stub(:kind).and_return 'item'
    end

    it 'returns the form url params to create path' do
      controller.should_receive(:send).with("purchase_process_item_creditor_proposals_path").and_return 'url'
      result = subject.create_params

      expect(result[:url]).to eql 'url'
      expect(result[:method]).to eql :post
    end
  end

  describe '#batch_update_params' do
    before do
      judgment_form.stub(:kind).and_return 'item'
    end

    it 'returns the form url params to batch update path' do
      controller.should_receive(:send).with("batch_update_purchase_process_item_creditor_proposals_path").and_return 'url'
      result = subject.batch_update_params

      expect(result[:url]).to eql 'url'
      expect(result[:method]).to eql :put
    end
  end
end
