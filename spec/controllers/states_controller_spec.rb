require 'spec_helper'

describe StatesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #new' do
    it 'should not have the route' do
      expect { get :new }.to raise_exception(ActionController::RoutingError)
    end
  end

  describe 'POST #create' do
    it 'should not have the route' do
      expect { post :create }.to raise_exception(ActionController::RoutingError)
    end
  end
end
