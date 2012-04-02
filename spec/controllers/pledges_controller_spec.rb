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

  it 'show the informed licitation when informed licitation is not nil' do
    pledge = Pledge.make!(:empenho, :licitation => "123/2031")

    get :edit, :id => pledge.id

    assigns(:pledge).licitation.should eq '123/2031'
  end

  it 'show the saved licitation when informed licitation is nil' do
    pledge = Pledge.make!(:empenho)

    get :edit, :id => pledge.id

    assigns(:pledge).licitation.should eq '001/2012'
  end

  it 'show the informed process when informed process is not nil' do
    pledge = Pledge.make!(:empenho, :process => "123/2031")

    get :edit, :id => pledge.id

    assigns(:pledge).process.should eq '123/2031'
  end

  it 'show the saved process when informed process is nil' do
    pledge = Pledge.make!(:empenho)

    get :edit, :id => pledge.id

    assigns(:pledge).process.should eq '002/2013'
  end

  it 'should call the budget allocation amount subtractor on action create' do
    Pledge.any_instance.stub(:licitation).and_return('39/2011')
    Pledge.any_instance.stub(:process).and_return('39/2011')
    Pledge.any_instance.stub(:valid?).and_return(true)

    PledgeBudgetAllocationSubtractor.any_instance.should_receive(:subtract_budget_allocation_amount!)

    post :create
  end

  it 'should call the GenerateNumberPledgeExpirations on action create' do
    GenerateNumberPledgeExpirations.any_instance.should_receive(:generate!)

    post :create
  end
end
