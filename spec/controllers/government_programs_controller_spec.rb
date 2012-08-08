require 'spec_helper'

describe GovernmentProgramsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET new' do
    it 'should use active as default status' do
      get :new

      expect(assigns(:government_program).status).to eq Status::ACTIVE
    end
  end

  context 'POST create' do
    it 'uses active as default value for status' do
      post :create

      expect(assigns(:government_program).status).to eq Status::ACTIVE
    end
  end
end
