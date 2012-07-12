require 'spec_helper'

describe PledgeLiquidationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
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

    it 'should use active as default status' do
      get :new

      assigns(:pledge_liquidation).status.should eq PledgeLiquidationStatus::ACTIVE
    end
  end

  context 'POST #create' do
    it 'should use active as default status' do
      post :create

      assigns(:pledge_liquidation).status.should eq PledgeLiquidationStatus::ACTIVE
    end

    it 'should call the GenerateNumberPledgeParcels on action create' do
      GenerateNumberParcels.any_instance.should_receive(:generate!)

      post :create
    end
  end
end
