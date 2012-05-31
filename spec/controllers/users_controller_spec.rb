require 'spec_helper'

describe UsersController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe '#new' do
    it 'the authenticable type should be Employee' do
      get :new

      assigns(:user).authenticable_type.should eq AuthenticableType::EMPLOYEE
    end
  end

  describe '#edit' do
    it 'when the authenticable type was not set it should be Employee' do
      User.stub(:find).and_return User.new
      
      get :edit

      assigns(:user).authenticable_type.should eq AuthenticableType::EMPLOYEE
    end
    
    it 'when the authenticable type was set, should keep this type' do
      User.stub(:find).and_return User.new(:authenticable_type => AuthenticableType::PROVIDER)
      
      get :edit

      assigns(:user).authenticable_type.should eq AuthenticableType::PROVIDER
    end
  end
end