require 'spec_helper'

describe UsersController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe '#edit' do
    it 'when the authenticable type is not employee should return 401' do
      User.stub(:find).and_return User.new(:authenticable_type => AuthenticableType::CREDITOR)

      get :edit

      response.code.should eq "401"
    end

    it 'when the user has no authenticable type should be editable' do
      User.stub(:find).and_return User.new(:authenticable_type => nil)

      get :edit

      response.should be_success
    end
  end

  describe '#create' do
    context 'user was successfully created' do
      it 'confirm the created user' do
        User.any_instance.should_receive(:save).and_return true
        User.any_instance.should_receive(:confirm!)
        post :create
      end

      it 'authenticable type should always be employee' do
        User.any_instance.should_receive(:save).and_return true
        User.any_instance.should_receive(:confirm!)

        post :create

        assigns(:user).authenticable_type.should eq AuthenticableType::EMPLOYEE
      end
    end
  end

  describe '#destroy' do
    it 'when the authenticable type is not employee should return 401' do
      User.stub(:find).and_return User.new(:authenticable_type => AuthenticableType::CREDITOR)

      get :destroy

      response.code.should eq "401"
    end

    it 'when the user has no authenticable type should be destroyed' do
      User.stub(:find).and_return User.new(:authenticable_type => nil)

      delete :destroy

      response.should redirect_to(users_path)
    end
  end

  describe '#update' do
    it 'when the authenticable type is not employee should return 401' do
      User.stub(:find).and_return User.new(:authenticable_type => AuthenticableType::CREDITOR)

      get :update

      response.code.should eq "401"
    end

    it 'when the user has no authenticable type should be editable' do
      User.stub(:find).and_return User.new(:authenticable_type => nil)

      put :update

      response.code.should eq "200"
    end
  end
end

