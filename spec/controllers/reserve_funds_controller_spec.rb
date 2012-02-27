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

  it 'show the informed licitation when informed licitation is not nil' do
    reserve_fund = ReserveFund.make!(:detran_2012, :licitation => "123/2031")

    get :edit, :id => reserve_fund.id

    assigns(:reserve_fund).licitation.should eq '123/2031'
  end

  it 'show the saved licitation when informed licitation is nil' do
    reserve_fund = ReserveFund.make!(:detran_2012)

    get :edit, :id => reserve_fund.id

    assigns(:reserve_fund).licitation.should eq '001/2012'
  end

  it 'show the informed process when informed process is not nil' do
    reserve_fund = ReserveFund.make!(:detran_2012, :process => "123/2031")

    get :edit, :id => reserve_fund.id

    assigns(:reserve_fund).process.should eq '123/2031'
  end

  it 'show the saved process when informed process is nil' do
    reserve_fund = ReserveFund.make!(:detran_2012)

    get :edit, :id => reserve_fund.id

    assigns(:reserve_fund).process.should eq '002/2013'
  end
end
