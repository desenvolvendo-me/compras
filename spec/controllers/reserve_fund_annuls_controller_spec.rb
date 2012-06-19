require 'spec_helper'

describe ReserveFundAnnulsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
    before do
      ReserveFund.stub(:find).with('1').and_return(reserve_fund)
      controller.stub(:current_user).and_return(double(:authenticable => authenticable, :creditor? => false))
    end

    let :reserve_fund do
      ReserveFund.new
    end

    let :authenticable do
      Employee.new
    end

    it 'uses current date as default value for date' do
      get :new, :reserve_fund_id => 1

      assigns(:reserve_fund_annul).date.should eq Date.current
    end

    it 'uses current employee as default value for employee' do
      get :new, :reserve_fund_id => 1

      assigns(:reserve_fund_annul).employee.should eq authenticable
    end
  end

  describe 'POST #create' do
    it 'should change reserve fund status' do
      reserve_fund = ReserveFund.make!(:detran_2012)
      ReserveFund.stub(:find).and_return(reserve_fund)
      ReserveFundAnnul.any_instance.stub(:reserve_fund).and_return(reserve_fund)
      ReserveFundStatusChanger.any_instance.should_receive(:change!)

      post :create
    end
  end
end
