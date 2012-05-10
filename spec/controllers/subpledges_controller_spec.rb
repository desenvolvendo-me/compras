require 'spec_helper'

describe SubpledgesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
    it 'should be empty if dont have any other subpledge' do
      Subpledge.stub(:any?).and_return(false)

      get :new

      assigns(:subpledge).date.should eq nil
    end

    it 'should set date as last subpledge' do
      Subpledge.stub(:any?).and_return(true)
      Subpledge.stub(:last).and_return(double(:date => Date.new(2012, 1, 1)))

      get :new

      assigns(:subpledge).date.should eq Date.new(2012, 1, 1)
    end
  end

  context 'POST #create' do
    it 'should assign the subpledge number' do
      Subpledge.any_instance.stub(:next_number).and_return(2)

      post :create

      assigns(:subpledge).number.should eq 2
    end

    it 'should call the GenerateNumberPledgeParcels on action create' do
      GenerateNumberPledgeParcels.any_instance.should_receive(:generate!)

      post :create

      assigns(:subpledge).number.should eq 1
    end
  end
end
