#encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationAnnulsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET 'new'" do
    let :authenticable do
      Employee.new
    end

    let :purchase_solicitation do
      PurchaseSolicitation.new
    end

    before do
      PurchaseSolicitation.stub(:find).and_return purchase_solicitation
      controller.stub(:current_user).and_return double('User', :authenticable => authenticable, :creditor? => false)

      get :new
    end

    it 'should have the current date as default date' do
      assigns(:purchase_solicitation_annul).date.should == Date.current
    end

    it 'should have current user related authenticable as default employee' do
      assigns(:purchase_solicitation_annul).employee.should == authenticable
    end

    it 'should have the given purchase solicitation as default annullable' do
      assigns(:purchase_solicitation_annul).annullable.should == purchase_solicitation
    end
  end

  describe "POST 'create'" do
    let :purchase_solicitation do
      PurchaseSolicitation.make!(:reparo)
    end

    before do
      ResourceAnnul.any_instance.stub(:save).and_return true
      ResourceAnnul.any_instance.stub(:annullable).and_return purchase_solicitation

      post :create
    end

    it 'should redirect to edit purchase solictation path' do
      response.should redirect_to edit_purchase_solicitation_path(purchase_solicitation)
    end
  end

  describe "PUT 'update'" do
    let :annul do
      double('Annul')
    end

    before do
      ResourceAnnul.stub(:find).and_return annul

      put :update
    end

    it 'should be unnacessible' do
      response.code.should eq '401'
      response.body.should =~ /Você não tem acesso a essa página/
    end
  end
end
