#encoding: utf-8
require 'spec_helper'

describe DirectPurchaseLiberationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET 'new'" do
    let :authenticable do
      Employee.new
    end

    let :direct_purchase do
      DirectPurchase.new
    end

    before do
      controller.stub(:current_user).and_return double('User', :authenticable => authenticable, :creditor? => false)
      DirectPurchase.stub(:find).and_return direct_purchase

      get :new, :direct_purchase_id => 1
    end

    it 'has the current user authenticable as default employee' do
      assigns(:direct_purchase_liberation).employee.should eq authenticable
    end

    it 'has the param direct purchase as default direct purchase' do
      assigns(:direct_purchase_liberation).direct_purchase.should eq direct_purchase
    end
  end

  describe "PUT 'update'" do
    before do
      DirectPurchaseLiberation.stub(:find).and_return double

      put :update
    end

    it 'should not be accessible' do
      response.code.should eq '401'
      response.body.should =~ /Você não tem acesso a essa página/
    end
  end
end
