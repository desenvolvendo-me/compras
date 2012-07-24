require 'spec_helper'

describe ContractTerminationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET 'new'" do
    before do
      Contract.stub(:find).and_return contract
      ContractTermination.stub(:next_number).and_return 1

      get :new
    end

    let :contract do
      Contract.new
    end

    it 'should assign the current year as default' do
      assigns(:contract_termination).year.should == Date.current.year
    end

    it 'should assign the sequential as the next based on the year' do
      assigns(:contract_termination).number.should == 1
    end

    it 'should assign the contract as default contract' do
      assigns(:contract_termination).contract.should == contract
    end
  end

  describe "POST 'create'" do
    let :contract do
      Contract.make!(:primeiro_contrato)
    end

    before do
      ContractTermination.any_instance.stub(:save).and_return true
      ContractTermination.any_instance.stub(:contract_id).and_return contract.id

      post :create
    end

    it 'should redirect to the index path passing the contract_id' do
      response.should redirect_to(contract_terminations_path(:contract_id => contract.id))
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

      put :update, :id => 1
    end

    it 'should redirect to the index path passing the contract_id' do
      response.should redirect_to(contract_terminations_path(:contract_id => contract.id))
    end
  end
end
