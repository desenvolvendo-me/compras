require 'decorator_helper'
require 'app/decorators/purchase_solicitation_budget_allocation_decorator'

describe PurchaseSolicitationBudgetAllocationDecorator do
  describe '#estimated_value' do
    it 'should return the number with precision' do
      component.stub(:estimated_value => 18.2)

      expect(subject.estimated_value).to eq '18,20'
    end
  end

  describe '#budget_allocation_balance' do
    it 'should return the number with precision' do
      component.stub(:budget_allocation_balance => 10)

      expect(subject.budget_allocation_balance).to eq '10,00'
    end
  end
end
