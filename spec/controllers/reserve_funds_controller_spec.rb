require 'spec_helper'

describe ReserveFundsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses reserved as default value for status on action new' do
    get :new

    expect(assigns(:reserve_fund).status).to eq ReserveFundStatus::RESERVED
  end

  it 'uses reserved as default value for status on action create' do
    post :create

    expect(assigns(:reserve_fund).status).to eq ReserveFundStatus::RESERVED
  end
end
