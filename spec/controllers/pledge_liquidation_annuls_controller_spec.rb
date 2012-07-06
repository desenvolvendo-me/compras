#encoding: utf-8
require 'spec_helper'

describe PledgeLiquidationAnnulsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #new' do
    let :authenticable do
      Employee.new
    end

    let :pledge_liquidation do
      PledgeLiquidation.new
    end

    before do
      PledgeLiquidation.stub(:find).and_return pledge_liquidation
      controller.stub(:current_user).and_return double('User', :authenticable => authenticable, :creditor? => false)

      get :new
    end

    it 'should have the current date as default date' do
      assigns(:pledge_liquidation_annul).date.should == Date.current
    end

    it 'should have current user related authenticable as default employee' do
      assigns(:pledge_liquidation_annul).employee.should == authenticable
    end

    it 'should have the given pledge_liquidation as default annullable' do
      assigns(:pledge_liquidation_annul).annullable.should == pledge_liquidation
    end
  end

  describe 'POST #create' do
    let :pledge_liquidation do
      PledgeLiquidation.make!(:empenho_2012)
    end

    before do
      ResourceAnnul.any_instance.stub(:save).and_return true
      ResourceAnnul.any_instance.stub(:annullable).and_return pledge_liquidation

      post :create
    end

    it 'should redirect to edit pledge_liquidation path' do
      response.should redirect_to edit_pledge_liquidation_path(pledge_liquidation)
    end
  end
end
