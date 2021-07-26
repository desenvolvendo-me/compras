require 'spec_helper'

describe LicitationProcessAppealsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
    it 'uses pending as default value for situation' do
      get :new

      expect(assigns(:licitation_process_appeal).situation).to eq Situation::PENDING
    end
  end
end
