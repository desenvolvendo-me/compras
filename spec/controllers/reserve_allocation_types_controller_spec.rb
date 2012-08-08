require 'spec_helper'

describe ReserveAllocationTypesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET new' do
    it 'should use active as default status' do
      get :new

      expect(assigns(:reserve_allocation_type).status).to eq Status::ACTIVE
    end
  end

  context 'POST create' do
    it 'uses manual as default value for source' do
      post :create

      expect(assigns(:reserve_allocation_type).source).to eq Source::MANUAL
    end

    it 'uses active as default value for status' do
      post :create

      expect(assigns(:reserve_allocation_type).status).to eq Status::ACTIVE
    end
  end
end
