# encoding: utf-8
require 'spec_helper'

describe ContractTerminationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'with contract_termination' do
    let(:contract_termination) {ContractTermination.make!(:contrato_rescindido) }
    let(:contract) { contract_termination.contract }

    describe 'GET #new' do
      it 'should return unauthorized' do
        get :new, :contract_id => contract.id

        expect(response.code).to eq '401'
        expect(response.body).to match(/Você não tem acesso a essa página/)
      end
    end

    describe 'POST #create' do
      it 'should return unauthorized' do
        post :create, :contract_id => contract.id

        expect(response.code).to eq '401'
        expect(response.body).to match(/Você não tem acesso a essa página/)
      end
    end
  end

  describe "GET 'new'" do
    let :contract do
      Contract.make!(:primeiro_contrato)
    end

    before do
      ContractTermination.stub(:next_number).and_return 1

      get :new, :contract_id => contract.id
    end

    it 'should assign the current year as default' do
      expect(assigns(:contract_termination).year).to eq Date.current.year
    end

    it 'should assign the sequential as the next based on the year' do
      expect(assigns(:contract_termination).number).to eq 1
    end

    it 'should assign the contract as default contract' do
      expect(assigns(:contract_termination).contract).to eq contract
    end
  end

  describe "POST 'create'" do
    let :contract do
      Contract.make!(:primeiro_contrato)
    end

    before do
      ContractTermination.any_instance.stub(:save).and_return true
      ContractTermination.any_instance.stub(:contract_id).and_return contract.id

      post :create, :contract_id => contract.id
    end

    it 'should redirect to edit contract' do
      expect(response).to redirect_to(edit_contract_path(contract))
    end
  end

  describe "PUT 'update'" do
    let :contract do
      Contract.make!(:primeiro_contrato)
    end

    before do
      ContractTermination.any_instance.stub(:save).and_return true
      ContractTermination.any_instance.stub(:contract_id).and_return contract.id
      ContractTermination.stub(:find).and_return ContractTermination.new

      put :update, :id => 1, :contract_id => contract.id
    end

    it 'should rredirect to edit contract' do
      expect(response).to redirect_to(edit_contract_path(contract))
    end
  end
end
