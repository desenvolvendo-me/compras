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
end
