#encoding: utf-8
require 'spec_helper'

describe DirectPurchasesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current employee as default value for employee' do
    get :new

    expect(assigns(:direct_purchase).employee).to eq controller.current_user.authenticable
  end

  it 'show today as default value for date' do
    get :new

    expect(assigns(:direct_purchase).date).to eq Date.current
  end

  it 'show current year as default value for year' do
    get :new

    expect(assigns(:direct_purchase).year).to eq Date.current.year
  end

  context 'next direct purchase' do
    let :direct_purchase do
      DirectPurchase.make!(:compra)
    end

    it 'should assign the direct purchase' do
      DirectPurchase.any_instance.stub(:next_purchase).and_return(2)

      post :create

      expect(assigns(:direct_purchase).direct_purchase).to eq 2
    end
  end

  context '#update' do
    let :direct_purchase do
      DirectPurchase.make!(:compra)
    end

    it 'should send e-mail to creditor on update' do
      SupplyAuthorizationMailer.should_receive(:authorization_to_creditor).with(direct_purchase).and_return(double(:deliver => true))

      put :update, :id => direct_purchase.id, :commit => 'Reenviar autorização de fornecimento por e-mail'
    end
  end
end
