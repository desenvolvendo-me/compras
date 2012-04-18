#encoding: utf-8
require 'spec_helper'

describe LicitationProcessImpugnmentsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #new' do
    it 'uses pending as default value for situation' do
      get :new

      assigns(:licitation_process_impugnment).situation.should eq Situation::PENDING
    end
  end

  describe 'POST #create' do
    it 'should has pending as default values for situation' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      post :create, :licitation_process_impugnment => { :licitation_process_id => licitation_process.id }

      assigns(:licitation_process_impugnment).situation.should eq Situation::PENDING
    end
  end

  describe 'PUT #UPDATE' do
    it "should can update any field when situation is pending " do
      licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

      put :update, :id => licitation_process_impugnment.id, :licitation_process_impugnment => {:valid_reason => "Outro motivo qualquer."}

      licitation_process_impugnment = LicitationProcessImpugnment.find(licitation_process_impugnment.id)
      licitation_process_impugnment.valid_reason.should eq "Outro motivo qualquer."
    end

    it "should can't update any field when situation is not pending " do
      licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras_deferida)

      put :update, :id => licitation_process_impugnment.id, :licitation_process_impugnment => {:valid_reason => "Outro motivo qualquer."}

      licitation_process_impugnment = LicitationProcessImpugnment.find(licitation_process_impugnment.id)
      licitation_process_impugnment.valid_reason.should eq "Não há a necessidade de comprar cadeiras."
    end
  end
end
