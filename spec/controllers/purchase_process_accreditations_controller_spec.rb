require 'spec_helper'

describe PurchaseProcessAccreditationsController, vcr: { cassette_name: 'controllers/purchase_process_accreditations' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)

    UnicoAPI::Consumer.set_customer customer
  end

  describe 'GET #new' do
    it 'should assing licitation_process by default' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      get :new, :licitation_process_id => licitation_process.id

      expect(assigns(:purchase_process_accreditation).licitation_process).to eq licitation_process
    end
  end

  describe 'POST #create' do
    it 'should redirect to edit_licitation_process_path' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      PurchaseProcessAccreditation.any_instance.should_receive(:save).and_return(true)

      post :create, :licitation_process_id => licitation_process.id

      expect(response).to redirect_to(edit_licitation_process_path(licitation_process))
    end
  end

  describe 'PUT #update' do
    it 'should redirect to edit_licitation_process_path' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      accreditation = PurchaseProcessAccreditation.create(:licitation_process_id => licitation_process.id)

      put :update, :id => accreditation.id, :licitation_process_id => licitation_process.id

      expect(response).to redirect_to(edit_licitation_process_path(licitation_process))
    end
  end
end
