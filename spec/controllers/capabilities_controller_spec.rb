require 'spec_helper'

describe CapabilitiesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      assigns(:capability).status.should eq Status::ACTIVE
    end
  end

  context '#create' do
    it 'should use active as default value for status' do
      post :create

      assigns(:capability).status.should eq Status::ACTIVE
    end

    it 'uses manual as default value for source' do
      post :create

      assigns(:capability).source.should eq Source::MANUAL
    end
  end
end
