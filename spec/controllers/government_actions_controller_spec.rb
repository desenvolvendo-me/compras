require 'spec_helper'

describe GovernmentActionsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET new' do
    it 'should have active as default status' do
      get :new

      expect(assigns(:government_action).status).to eq Status::ACTIVE
    end
  end

  context 'POST create' do
    it 'should have active as default for status' do
      post :create

      expect(assigns(:government_action).status).to eq Status::ACTIVE
    end
  end
end
