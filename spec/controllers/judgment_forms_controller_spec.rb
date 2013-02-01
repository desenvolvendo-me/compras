#encoding: utf-8
require 'spec_helper'

describe JudgmentFormsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #new' do
    it 'should not allow new' do
      expect { get :new }.to raise_exception(ActionController::RoutingError)
    end
  end

  describe 'POST #create' do
    it 'should not allow creation' do
      expect { post :create }.to raise_exception(ActionController::RoutingError)
    end
  end

  describe 'DELETE #destroy' do
    it 'should not allow deletion' do
      expect { delete :destroy }.to raise_exception(ActionController::RoutingError)
    end
  end
end
