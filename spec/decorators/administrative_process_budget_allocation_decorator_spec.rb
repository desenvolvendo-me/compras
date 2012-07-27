# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_decorator'

describe AdministrativeProcessBudgetAllocationDecorator do
  it 'should return budget_allocation_amount' do
    component.stub(:budget_allocation_amount).and_return(10)

    subject.budget_allocation_amount.should eq "10,00"
  end

  it 'should return value' do
    component.stub(:value).and_return(15)

    subject.value.should eq "15,00"
  end

  context '#total_items_value' do
    before do
      component.stub(:total_items_value).and_return(100)
    end

    it 'should return total items value' do
      subject.total_items_value.should eq "100,00"
    end
  end
end
