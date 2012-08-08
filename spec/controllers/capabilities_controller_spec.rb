require 'spec_helper'

describe CapabilitiesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      expect(assigns(:capability).status).to eq Status::ACTIVE
    end
  end

  context '#create' do
    it 'should use active as default value for status' do
      post :create

      expect(assigns(:capability).status).to eq Status::ACTIVE
    end

    it 'uses manual as default value for source' do
      post :create

      expect(assigns(:capability).source).to eq Source::MANUAL
    end
  end
end
