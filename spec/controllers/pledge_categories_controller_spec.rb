require 'spec_helper'

describe PledgeCategoriesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      assigns(:pledge_category).status.should eq Status::ACTIVE
    end
  end

  context '#create' do
    it 'uses manual as default value for source' do
      post :create

      assigns(:pledge_category).source.should eq Source::MANUAL
    end

    it 'should use active as default value for status' do
      post :create

      assigns(:pledge_category).status.should eq Status::ACTIVE
    end
  end
end
