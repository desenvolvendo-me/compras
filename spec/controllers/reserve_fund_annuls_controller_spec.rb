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

    it 'return 401 when reserve_fund is already annulled' do
      reserve_fund.stub(:status => ReserveFundStatus::ANNULLED)

      get :new, :reserve_fund_id => 1

      response.code.should eq "401"
    end
  end

  describe 'POST #create' do
    it 'should change reserve fund status' do
      reserve_fund = ReserveFund.make!(:detran_2012)
      ReserveFund.any_instance.should_receive(:annul!)

      post :create, :resource_annul => { :annullable_id => reserve_fund.id }
    end

    it 'should return 401 is reserve_fund is already annulled' do
      reserve_fund = ReserveFund.make!(:anulado)

      post :create, :resource_annul => { :annullable_id => reserve_fund.id }

      response.code.should eq "401"
    end
  end
end
