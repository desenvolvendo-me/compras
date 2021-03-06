require 'spec_helper'

describe LicitationProcessImpugnmentsController, vcr: { cassette_name: 'controllers/licitation_process_impugnments' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)

    UnicoAPI::Consumer.set_customer customer
  end

  describe 'GET #new' do
    it 'uses pending as default value for situation' do
      get :new

      expect(assigns(:licitation_process_impugnment).situation).to eq Situation::PENDING
    end
  end

  describe 'POST #create' do
    it 'should has pending as default values for situation' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      post :create, :licitation_process_impugnment => { :licitation_process_id => licitation_process.id }

      expect(assigns(:licitation_process_impugnment).situation).to eq Situation::PENDING
    end
  end

  describe 'PUT #UPDATE' do
    it "should can update any field when situation is pending " do
      licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

      put :update, :id => licitation_process_impugnment.id, :licitation_process_impugnment => {:valid_reason => "Outro motivo qualquer."}

      licitation_process_impugnment = LicitationProcessImpugnment.find(licitation_process_impugnment.id)
      expect(licitation_process_impugnment.valid_reason).to eq "Outro motivo qualquer."
    end

    it "should can't update any field when situation is not pending " do
      licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras_deferida)

      put :update, :id => licitation_process_impugnment.id, :licitation_process_impugnment => {:valid_reason => "Outro motivo qualquer."}

      licitation_process_impugnment = LicitationProcessImpugnment.find(licitation_process_impugnment.id)
      expect(licitation_process_impugnment.valid_reason).to eq "Não há a necessidade de comprar cadeiras."
    end
  end
end
