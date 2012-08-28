require 'spec_helper'

describe PrecatoryTypesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      expect(assigns(:precatory_type).status).to eq Status::ACTIVE
    end
  end

  context '#post' do
    it 'should use active as default value for status' do
      post :create

      expect(assigns(:precatory_type).status).to eq Status::ACTIVE
    end
  end
end
