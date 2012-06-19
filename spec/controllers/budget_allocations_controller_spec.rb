require 'spec_helper'

describe BudgetAllocationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'POST #create' do
    it 'should assign the budget_allocation code' do
      BudgetAllocation.any_instance.stub(:next_code).and_return(2)

      post :create

      assigns(:budget_allocation).code.should eq 2
    end
  end
end
