require 'spec_helper'

describe ExpenseNaturesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'POST #create' do
    it 'should generate full code' do
      ExpenseNatureCodeGenerator.any_instance.should_receive(:generate!)

      post :create
    end
  end

  context 'PUT #update' do
    it 'should update full code' do
      expense_nature = ExpenseNature.make!(:vencimento_e_salarios)
      ExpenseNature.stub(:find).and_return(expense_nature)

      ExpenseNatureCodeGenerator.any_instance.should_receive(:generate!)

      put :update, :id => '1'
    end
  end
end
