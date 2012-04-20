require 'spec_helper'

describe PledgesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current date as default value for emission date' do
    get :new

    assigns(:pledge).emission_date.should eq Date.current
  end

  it 'should call the budget allocation amount subtractor on action create' do
    Pledge.any_instance.stub(:valid?).and_return(true)

    PledgeBudgetAllocationSubtractor.any_instance.should_receive(:subtract_budget_allocation_amount!)

    post :create
  end

  it 'should call the GenerateNumberPledgeExpirations on action create' do
    GenerateNumberPledgeExpirations.any_instance.should_receive(:generate!)

    post :create
  end
end
