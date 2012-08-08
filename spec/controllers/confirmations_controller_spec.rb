require 'spec_helper'

describe ConfirmationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    User.stub(:find_by_confirmation_token).and_return user
  end

  let :user do
    User.new
  end

  describe '#show' do
    context 'the user has not confirmed your account yet' do
      it 'should render the confirm page' do
        user.should_receive(:confirmed?).and_return false
        get :show
        expect(response).to be_success
      end
    end

    context 'the user has confirmed your account' do
      it 'should render the root page' do
        User.stub(:confirm_by_token).and_return user
        user.stub_chain(:errors, :empty?).and_return true

        user.should_receive(:confirmed?).at_least(:once).and_return true
        get :show
        expect(response).to redirect_to(root_path)
      end
    end

    context "has no user with the token 'abc'" do
      before do
        User.stub(:find_by_confirmation_token).with('abc').and_return nil
      end

      it 'should redirect to the root path' do
        get :show, :confirmation_token => 'abc'

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#confirm' do
    it 'updates the user password and confirm the account' do
      user.should_receive(:update_attributes).and_return true
      User.should_receive(:confirm_by_token).and_return user

      put :confirm, :user => { :password => 'foobar', :password_confirmation => 'foobar' }
    end
  end
end
