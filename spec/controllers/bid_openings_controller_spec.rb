require 'spec_helper'

describe BidOpeningsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses waiting as default value for status' do
      get :new

      assigns(:bid_opening).bid_opening_status.should eq BidOpeningStatus::WAITING
    end

    it 'uses current date as default value for date' do
      get :new

      assigns(:bid_opening).date.should eq Date.current
    end

    it 'uses current year as default value for year' do
      get :new

      assigns(:bid_opening).year.should eq Date.current.year
    end

    it 'uses current employee as default value for employee' do
      get :new

      assigns(:bid_opening).responsible.should eq controller.current_user.employee
    end
  end

  context 'POST #create' do
    it 'uses waiting as default value for status' do
      post :create

      assigns(:bid_opening).bid_opening_status.should eq BidOpeningStatus::WAITING
    end
  end
end
