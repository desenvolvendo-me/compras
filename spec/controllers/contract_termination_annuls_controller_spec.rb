#encoding: utf-8
require 'spec_helper'

describe ContractTerminationAnnulsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context "with contract termination" do
    before do
      controller.stub(:current_user).and_return double(:authenticable => authenticable, :creditor? => false)
    end

    let :authenticable do
      Employee.new
    end

    let :contract_termination do
      ContractTermination.make!(:contrato_rescindido)
    end

    it 'uses current date as default value for date' do
      get :new, :contract_termination_id => contract_termination.id

      assigns(:contract_termination_annul).date.should eq Date.current
    end

    it 'uses current employee as default value for employee' do
      get :new, :contract_termination_id => contract_termination.id

      assigns(:contract_termination_annul).employee.should eq authenticable 
    end

    it 'uses current contract termination' do
      get :new, :contract_termination_id => contract_termination.id

      assigns(:contract_termination_annul).annullable.should eq contract_termination
    end

    it 'should assign the process' do
      ResourceAnnul.any_instance.stub(:annullable).and_return(contract_termination)

      post :create, :resource_annul => { :annullable_id => contract_termination.id }

      assigns(:contract_termination_annul).annullable eq contract_termination
    end
  end

  context "contract_termination annulled" do
    before do
      ContractTermination.stub(:find).with('1').and_return(contract_termination)
    end

    let :contract_termination do
      double(:contract_termination, :annulled? => true)
    end

    describe "#new" do
      it "should return 404" do
        get :new, :contract_termination_id => 1

        response.code.should eq "401"
      end
    end

    describe "#create" do
      it "should return 404" do
        post :create, :resource_annul => { :annullable_id => 1 }

        response.code.should eq "401"
      end
    end
  end

  describe "#update" do
    it "should return 404" do
      put :update

      response.code.should eq "401"
    end
  end
end

