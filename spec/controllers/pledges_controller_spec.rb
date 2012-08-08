require 'spec_helper'

describe PledgesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current date as default value for emission date' do
    get :new

    expect(assigns(:pledge).emission_date).to eq Date.current
  end

  it 'should call the budget allocation amount subtractor on action create' do
    Pledge.any_instance.stub(:valid?).and_return(true)

    PledgeBudgetAllocationSubtractor.any_instance.should_receive(:subtract_budget_allocation_amount!)

    post :create
  end
end
