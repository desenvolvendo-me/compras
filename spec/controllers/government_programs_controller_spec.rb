require 'spec_helper'

describe GovernmentProgramsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET new' do
    it 'should use active as default status' do
      get :new

      assigns(:government_program).status.should eq Status::ACTIVE
    end
  end

  context 'POST create' do
    it 'uses active as default value for status' do
      post :create

      assigns(:government_program).status.should eq Status::ACTIVE
    end
  end
end
