require 'spec_helper'

describe UsersController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe '#edit' do
    it 'when the user has Employee as authenticable type should be editable' do
      user = User.make!(:sobrinho)

      get :edit, user.attributes

      response.should be_success
    end

    it 'when the user does not have Employee as authenticable type should not be editable' do
      user = User.make!(:creditor_with_password)

      assert_raise ActiveRecord::RecordNotFound do
        get :edit, user.attributes
      end
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
    it 'when the user has Employee as authenticable type should be destroyed' do
      user = User.make!(:sobrinho)

      delete :destroy, user.attributes

      response.should redirect_to(users_path)
    end

    it 'when the user does no have Employee as authenticable type should not be destroyed' do
      user = User.make!(:creditor_with_password)

      assert_raise ActiveRecord::RecordNotFound do
        delete :destroy, user.attributes
      end
    end
  end

  describe '#update' do
    it 'when the user has no authenticable type should be editable' do
      user = User.make!(:sobrinho)

      put :update, user.attributes

      response.should redirect_to(users_path)
    end

    it 'when the user does not have Employee as authenticable type should not be editable' do
      user = User.make!(:creditor_with_password)

      assert_raise ActiveRecord::RecordNotFound do
        put :update, user.attributes
      end
    end
  end
end

