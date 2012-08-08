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

      expect(assigns(:pledge_liquidation).date).to eq nil
    end

    it 'should set date as last pledge_liquidation' do
      PledgeLiquidation.stub(:any?).and_return(true)
      PledgeLiquidation.stub(:last).and_return(double(:date => Date.new(2012, 1, 1)))

      get :new

      expect(assigns(:pledge_liquidation).date).to eq Date.new(2012, 1, 1)
    end

    it 'should use active as default status' do
      get :new

      expect(assigns(:pledge_liquidation).status).to eq PledgeLiquidationStatus::ACTIVE
    end
  end

  context 'POST #create' do
    it 'should use active as default status' do
      post :create

      expect(assigns(:pledge_liquidation).status).to eq PledgeLiquidationStatus::ACTIVE
    end

    it 'should call the GenerateNumberPledgeParcels on action create' do
      ParcelNumberGenerator.any_instance.should_receive(:generate!)

      post :create
    end
  end
end
