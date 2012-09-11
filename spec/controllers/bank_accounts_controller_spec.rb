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
    it 'should use active as default value for status and call status verifier' do
      BankAccount.any_instance.should_receive(:transaction).and_yield

      BankAccountCapabilitiesStatusVerifier.any_instance.should_receive(:verify!)

      post :create

      expect(assigns(:bank_account).status).to eq Status::ACTIVE
    end
  end

  context '#update' do
    it 'should call status verifier' do
      bank_account = BankAccount.make!(:itau_tributos)

      BankAccountCapabilitiesStatusVerifier.any_instance.should_receive(:verify!)

      post :update, :id => bank_account.id
    end
  end
end
