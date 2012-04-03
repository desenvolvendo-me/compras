require 'spec_helper'

describe PurchaseSolicitationsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses pending as default value for service_status' do
      get :new

      assigns(:purchase_solicitation).service_status.should eq PurchaseSolicitationServiceStatus::PENDING
    end

    it 'uses current year as default value for year' do
      get :new

      assigns(:purchase_solicitation).accounting_year.should eq Date.current.year
    end

    it 'uses current date as default value for date' do
      get :new

      assigns(:purchase_solicitation).request_date.should eq Date.current
    end

    it 'uses current employee as default value for employee' do
      get :new

      assigns(:purchase_solicitation).responsible.should eq controller.current_user.employee
    end
  end

  context 'POST #create' do
    it 'should mark purchase_solicitation as pending' do
      post :create

      assigns(:purchase_solicitation).service_status.should eq PurchaseSolicitationServiceStatus::PENDING
    end
  end
end
