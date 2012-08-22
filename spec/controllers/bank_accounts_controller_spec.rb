require 'spec_helper'

describe BankAccountsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      expect(assigns(:bank_account).status).to eq Status::ACTIVE
    end
  end

  context '#create' do
    it 'should use active as default value for status' do
      post :create

      expect(assigns(:bank_account).status).to eq Status::ACTIVE
    end
  end
end
