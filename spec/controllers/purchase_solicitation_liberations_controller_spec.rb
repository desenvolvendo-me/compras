#encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationLiberationsController do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  before do
    controller.stub(:current_user).and_return(current_user)
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
    BudgetStructure.stub(:find)
  end

  context "with purchase_solicitation GET#new" do
    let :purchase_solicitation do
      PurchaseSolicitation.make!(:reparo)
    end

    before do
      get :new, :purchase_solicitation_id => purchase_solicitation.id
    end

    it 'should have the current date as default date' do
      expect(assigns(:purchase_solicitation_liberation).date).to eq Date.current
    end

    it 'should have current user related authenticable as default responsible' do
      expect(assigns(:purchase_solicitation_liberation).responsible).to eq current_user.authenticable
    end

    it 'should have the given purchase solicitation as default purchase_solicitation' do
      expect(assigns(:purchase_solicitation_liberation).purchase_solicitation).to eq purchase_solicitation
    end
  end

  describe "with purchase_solicitation POST#create" do
    let :purchase_solicitation do
      PurchaseSolicitation.make!(:reparo)
    end

    before do
      PurchaseSolicitationLiberation.any_instance.stub(:save).and_return true
      PurchaseSolicitationLiberation.any_instance.stub(:purchase_solicitation).and_return(purchase_solicitation)

      post :create, :purchase_solicitation_liberation => { :purchase_solicitation_id => purchase_solicitation.id }
    end

    it 'should assign the purchase solicitation' do
      expect(assigns(:parent).id).to eq purchase_solicitation.id
    end

    it 'should redirect to index' do
      expect(response).to redirect_to purchase_solicitation_liberations_path(:purchase_solicitation_id => purchase_solicitation.id)
    end
  end

  it 'GET #new with purchase solicitation liberated' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

    get :new, :purchase_solicitation_id => purchase_solicitation.id

    expect(response.code).to eq '401'
  end
end
