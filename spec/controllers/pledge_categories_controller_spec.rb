require 'spec_helper'

describe PledgeCategoriesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      expect(assigns(:pledge_category).status).to eq Status::ACTIVE
    end
  end

  context '#create' do
    it 'uses manual as default value for source' do
      post :create

      expect(assigns(:pledge_category).source).to eq Source::MANUAL
    end

    it 'should use active as default value for status' do
      post :create

      expect(assigns(:pledge_category).status).to eq Status::ACTIVE
    end
  end
end
