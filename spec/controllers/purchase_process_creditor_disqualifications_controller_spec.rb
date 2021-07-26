require 'spec_helper'

describe PurchaseProcessCreditorDisqualificationsController do
  let(:licitation_process) { LicitationProcess.new }
  let(:creditor)           { Creditor.new }
  let(:resource)           { double(:resource, licitation_process: 1) }
  let(:localized_resource) { double(:localized_resource, licitation_process: 1) }

  before do
    subject.stub(:authenticate_user!)
    subject.stub(:authorize_resource!)

    PurchaseProcessCreditorDisqualification.stub(:find).and_return resource
    LicitationProcess.stub(:find).and_return licitation_process
    Creditor.stub(:find).and_return creditor
  end

  describe 'GET new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    before { subject.stub(:build_resource).and_return resource }

    context 'when saving is successfully' do
      it 'should redirect to creditors proposals' do
        resource.stub(:save).and_return true
        resource.stub(:errors).and_return []
        subject.stub(:creditor_proposals_path).and_return 'proposals_path'
        post :create

        expect(response).to redirect_to('proposals_path')
      end
    end

    context 'when saving is not successfully' do
      it 'renders the new template' do
        resource.stub(:save).and_return false
        resource.stub(:errors).and_return [double(:error)]
        post :create

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET edit' do
    it 'renders the edit template' do
      get :edit, id: 1
      expect(response).to render_template :edit
    end
  end

  describe 'PUT update' do
    before do
      resource.stub(:localized).and_return localized_resource
    end

    context 'when saving is successfully' do
      it 'should redirect to creditors proposals' do
        localized_resource.stub(:update_attributes).and_return true
        resource.stub(:errors).and_return []
        subject.stub(:creditor_proposals_path).and_return 'proposals_path'
        put :update, id: 1

        expect(response).to redirect_to 'proposals_path'
      end
    end

    context 'when saving is not successfully' do
      it 'renders the edit template' do
        localized_resource.stub(:update_attributes).and_return false
        resource.stub(:errors).and_return [double(:error)]
        put :update, id: 1

        expect(response).to render_template :edit
      end
    end
  end
end
