require 'spec_helper'

describe PurchaseProcessCreditorProposalsController do
  let(:licitation_process) { double :licitation_process, id: 1, to_s: 1 }
  let(:creditor)           { double :creditor }
  let(:creditors)          { double :creditors, includes: :purchase_process_creditor_proposals }
  let(:localized_licitation_process) { double :localized_licitation_process }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
    LicitationProcess.stub(:find).and_return licitation_process
    Creditor.stub(:find).and_return creditor
  end

  describe 'GET new' do
    it 'renders the new template' do
      TradingCreator.should_receive(:create!).with(licitation_process)

      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    before do
      licitation_process.stub(:localized).and_return localized_licitation_process
      localized_licitation_process.stub(:assign_attributes)
    end

    context 'when saving is successfully' do
      before do
        licitation_process.should_receive(:save).and_return true
      end

      it 'should redirect to creditors proposals' do
        post :create
        expect(response).to redirect_to(creditors_purchase_process_creditor_proposals_path(licitation_process_id: 1))
      end
    end

    context 'when saving is not successfully' do
      before do
        licitation_process.should_receive(:save).and_return false
      end

      it 'should render the new template' do
        post :create
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET batch_edit' do
    it 'renders the batch_edit template' do
      get :batch_edit
      expect(response).to render_template :batch_edit
    end
  end

  describe 'PUT batch_update' do
    before do
      licitation_process.stub(:localized).and_return localized_licitation_process
      localized_licitation_process.stub(:assign_attributes)
    end

    context 'when updating is successfully' do
      before do
        licitation_process.should_receive(:save).and_return true
      end

      it 'should redirect to creditors proposals' do
        put :batch_update
        expect(response).to redirect_to(creditors_purchase_process_creditor_proposals_path(licitation_process_id: 1))
      end
    end

    context 'when updating is not successfully' do
      before do
        licitation_process.should_receive(:save).and_return false
      end

      it 'should render the batch_edit template' do
        put :batch_update
        expect(response).to render_template :batch_edit
      end
    end
  end

  describe 'GET creditors' do
    it 'renders the creditors template' do
      licitation_process.should_receive(:creditors).and_return creditors
      creditors.should_receive(:includes).with(:purchase_process_creditor_proposals)

      get :creditors
      expect(response).to render_template :creditors
    end
  end
end
