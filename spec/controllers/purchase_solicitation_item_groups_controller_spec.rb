require 'spec_helper'

describe PurchaseSolicitationItemGroupsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'POST #create' do
    before do
      PurchaseSolicitationItemGroup.any_instance.stub(:save).and_return true
    end

    it 'should create an item group' do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.any_instance.should_receive(:change)

      post :create
    end
  end

  describe 'PUT #update' do
    before do
      PurchaseSolicitationItemGroup.any_instance.stub(:save).and_return true
    end

    it 'should update an item group' do
      purchase_solicitation_item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      PurchaseSolicitationBudgetAllocationItemStatusChanger.any_instance.should_receive(:change)

      put :update, :id => purchase_solicitation_item_group.id
    end
  end

  describe 'DELETE #destroy' do
    it 'should update an item group' do
      purchase_solicitation_item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      expect { delete :destroy, :id => purchase_solicitation_item_group.id }.to raise_exception(ActionController::RoutingError)
    end
  end
end
