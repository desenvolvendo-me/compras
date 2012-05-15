require 'spec_helper'

describe PledgeLiquidationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'should be empty if dont have any other pledge_liquidation' do
    PledgeLiquidation.stub(:any?).and_return(false)

    get :new

    assigns(:pledge_liquidation).date.should eq nil
  end

  it 'should set date as last pledge_liquidation' do
    PledgeLiquidation.stub(:any?).and_return(true)
    PledgeLiquidation.stub(:last).and_return(double(:date => Date.new(2012, 1, 1)))

    get :new

    assigns(:pledge_liquidation).date.should eq Date.new(2012, 1, 1)
  end

  it 'should call the PledgeParcelMovimentationGenerator on action create' do
    PledgeLiquidation.any_instance.stub(:valid?).and_return(true)

    PledgeParcelMovimentationGenerator.any_instance.should_receive(:generate!)

    post :create
  end
end
