require 'spec_helper'

describe JudgmentFormsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #edit' do
    it 'should not allow new' do
      expect { get :edit }.to raise_exception(ActionController::RoutingError)
    end
  end

  describe 'DELETE #destroy' do
    it 'should not allow deletion' do
      expect { delete :destroy }.to raise_exception(ActionController::RoutingError)
    end
  end
end
