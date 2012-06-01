require 'spec_helper'

describe ExpenseKindsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context '#new' do
    it 'should use active as default value for status' do
      get :new

      assigns(:expense_kind).status.should eq Status::ACTIVE
    end
  end

  context '#create' do
    it 'should use active as default value for status' do
      post :create

      assigns(:expense_kind).status.should eq Status::ACTIVE
    end
  end
end
