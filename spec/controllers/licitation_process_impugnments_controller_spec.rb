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
    it 'should has default values for situation, and envelope dates' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      post :create, :licitation_process_impugnment => { :licitation_process_id => licitation_process.id }

      assigns(:licitation_process_impugnment).situation.should eq Situation::PENDING
      assigns(:licitation_process_impugnment).envelope_delivery_date.should eq licitation_process.envelope_delivery_date
      assigns(:licitation_process_impugnment).envelope_delivery_time.should eq licitation_process.envelope_delivery_time
      assigns(:licitation_process_impugnment).envelope_opening_date.should eq licitation_process.envelope_opening_date
      assigns(:licitation_process_impugnment).envelope_opening_time.should eq licitation_process.envelope_opening_time
    end
  end
end
