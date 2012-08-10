require 'spec_helper'

describe BudgetStructuresController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'PUT #update' do
    let :budget do
      BudgetStructure.new
    end

    before do
      BudgetStructure.stub(:find).and_return(budget)
    end

    it 'should call BudgetStructureResponsibleEndDateGenerator' do
      BudgetStructureResponsibleEndDateGenerator.any_instance.should_receive(:change!).and_return(true)

      put :update, :id => 1
    end
  end
end
