require 'spec_helper'

describe RevenueAccountingsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'POST #create' do
    it 'should assign the licitation notice code' do
      RevenueAccounting.any_instance.stub(:next_code).and_return(2)

      post :create

      assigns(:revenue_accounting).code.should eq 2
    end
  end
end
