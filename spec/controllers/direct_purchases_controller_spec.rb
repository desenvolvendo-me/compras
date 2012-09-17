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

  context 'POST #create' do
    it 'should assign the direct purchase' do
      direct_purchase = DirectPurchase.make!(:compra)
      DirectPurchase.any_instance.stub(:next_purchase).and_return(2)

      post :create

      expect(assigns(:direct_purchase).direct_purchase).to eq 2
    end

    it 'should assign the fulfill of purchase_solicitation_budget_allocation_item' do
      DirectPurchase.any_instance.stub(:transaction).and_yield
      PurchaseSolicitationBudgetAllocationItemFulfiller.any_instance.should_receive(:fulfill)

      post :create
    end
  end

  context '#update' do
    let :direct_purchase do
      DirectPurchase.make!(:compra)
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte)
    end

    let :pdf do
      double(:pdf)
    end

    let :html do
      double(:html)
    end

    it 'should send e-mail to creditor on update' do
      Pdf.any_instance.should_receive(:generate!).and_return(html)

      SupplyAuthorizationMailer.should_receive(:authorization_to_creditor).with(direct_purchase, prefecture, html).and_return(double(:deliver => true))

      put :update, :id => direct_purchase.id, :commit => 'Enviar autorização de fornecimento por e-mail'
    end
  end
end
