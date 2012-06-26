require 'spec_helper'

describe ReserveFundsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses reserved as default value for status on action new' do
    get :new

    assigns(:reserve_fund).status.should eq ReserveFundStatus::RESERVED
  end

  it 'uses reserved as default value for status on action create' do
    post :create

    assigns(:reserve_fund).status.should eq ReserveFundStatus::RESERVED
  end
end
