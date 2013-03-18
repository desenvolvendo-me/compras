require 'spec_helper'

describe PurchaseSolicitationsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses pending as default value for service_status' do
      get :new

      expect(assigns(:purchase_solicitation).service_status).to eq PurchaseSolicitationServiceStatus::PENDING
    end

    it 'uses current year as default value for year' do
      get :new

      expect(assigns(:purchase_solicitation).accounting_year).to eq Date.current.year
    end

    it 'uses current date as default value for date' do
      get :new

      expect(assigns(:purchase_solicitation).request_date).to eq Date.current
    end

    it 'uses current employee as default value for employee' do
      get :new

      expect(assigns(:purchase_solicitation).responsible).to eq controller.current_user.authenticable
    end
  end

  context 'POST #create' do
    it 'should mark purchase_solicitation as pending' do
      post :create

      expect(assigns(:purchase_solicitation).service_status).to eq PurchaseSolicitationServiceStatus::PENDING
    end
  end

  context 'PUT #update' do
    it 'should return 401 when is not editable' do
      purchase_solicitation = double(:purchase_solicitation, :id => 1,
                                     :editable? => false)

      PurchaseSolicitation.stub(:find).and_return(purchase_solicitation)

      put :update, :id => 1

      expect(response.code).to eq "401"
    end

    it 'should allow edit when is editable' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      put :update, :id => purchase_solicitation.id,
                   :purchase_solicitation => { :accounting_year => 2013 }

      expect(assigns(:purchase_solicitation).accounting_year).to eq 2013
    end

    it 'should redirect to edit' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      put :update, :id => purchase_solicitation.id

      expect(response).to redirect_to(edit_purchase_solicitation_path(purchase_solicitation))
    end
  end
end
