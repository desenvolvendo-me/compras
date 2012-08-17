require 'spec_helper'

describe ApplicationCodesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use manual as default value for source' do
      get :new

      expect(assigns(:application_code).source).to eq Source::MANUAL
    end
  end

  context '#create' do
    it 'uses manual as default value for source' do
      post :create

      expect(assigns(:application_code).source).to eq Source::MANUAL
    end
  end
end
